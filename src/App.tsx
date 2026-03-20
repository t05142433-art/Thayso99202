import React, { useState } from "react";
import { motion } from "motion/react";
import { Tv, Key, User, Globe, CheckCircle } from "lucide-react";

export default function App() {
  const [code, setCode] = useState("");
  const [host, setHost] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle");
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus("loading");
    setError("");

    try {
      const response = await fetch("/api/pair/submit", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code, host, username, password }),
      });

      if (!response.ok) throw new Error("Código inválido ou expirado.");
      
      setStatus("success");
    } catch (err: any) {
      setStatus("error");
      setError(err.message);
    }
  };

  if (status === "success") {
    return (
      <div className="min-h-screen bg-[#050505] text-white flex items-center justify-center p-6 font-sans">
        <motion.div 
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="max-w-md w-full bg-[#101010] border-2 border-[#00FFFF] rounded-3xl p-10 text-center shadow-[0_0_50px_rgba(0,255,255,0.3)]"
        >
          <CheckCircle className="w-20 h-20 text-[#00FFFF] mx-auto mb-6" />
          <h1 className="text-3xl font-bold mb-4 text-[#00FFFF]">CONECTADO!</h1>
          <p className="text-gray-400 text-lg">Sua TV já está sincronizando. Você já pode fechar esta aba.</p>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#050505] text-white flex items-center justify-center p-6 font-sans">
      <div className="fixed inset-0 overflow-hidden pointer-events-none opacity-20">
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-[#FF00FF] blur-[150px] rounded-full" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-[#00FFFF] blur-[150px] rounded-full" />
      </div>

      <motion.div 
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        className="max-w-md w-full bg-[#101010] border-2 border-[#FF00FF]/30 rounded-3xl p-8 shadow-2xl relative z-10"
      >
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-[#FF00FF]/10 rounded-2xl mb-4 border border-[#FF00FF]/50">
            <Tv className="w-8 h-8 text-[#FF00FF]" />
          </div>
          <h1 className="text-2xl font-bold tracking-tight">Thayson & Thayla IPTV</h1>
          <p className="text-gray-500 text-sm mt-2 uppercase tracking-widest">Ativação de Dispositivo</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <label className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-2">
              <Key className="w-3 h-3" /> Código da TV
            </label>
            <input
              required
              type="text"
              maxLength={6}
              placeholder="Ex: 123456"
              value={code}
              onChange={(e) => setCode(e.target.value)}
              className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-2xl font-mono tracking-[0.5em] text-center focus:border-[#FF00FF] focus:ring-1 focus:ring-[#FF00FF] outline-none transition-all"
            />
          </div>

          <div className="space-y-2">
            <label className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-2">
              <Globe className="w-3 h-3" /> URL do Servidor (Host)
            </label>
            <input
              required
              type="url"
              placeholder="http://exemplo.com:8080"
              value={host}
              onChange={(e) => setHost(e.target.value)}
              className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 focus:border-[#00FFFF] focus:ring-1 focus:ring-[#00FFFF] outline-none transition-all"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-2">
                <User className="w-3 h-3" /> Usuário
              </label>
              <input
                required
                type="text"
                placeholder="Seu user"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 focus:border-[#FF00FF] focus:ring-1 focus:ring-[#FF00FF] outline-none transition-all"
              />
            </div>
            <div className="space-y-2">
              <label className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-2">
                <Key className="w-3 h-3" /> Senha
              </label>
              <input
                required
                type="password"
                placeholder="Sua senha"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 focus:border-[#FF00FF] focus:ring-1 focus:ring-[#FF00FF] outline-none transition-all"
              />
            </div>
          </div>

          {error && (
            <div className="bg-red-500/10 border border-red-500/50 text-red-500 text-xs p-3 rounded-xl text-center">
              {error}
            </div>
          )}

          <button
            disabled={status === "loading"}
            type="submit"
            className="w-full bg-gradient-to-r from-[#FF00FF] to-[#00FFFF] text-black font-bold py-4 rounded-xl hover:opacity-90 transition-opacity disabled:opacity-50 shadow-[0_0_20px_rgba(255,0,255,0.3)]"
          >
            {status === "loading" ? "CONECTANDO..." : "ENVIAR PARA TV"}
          </button>
        </form>

        <div className="mt-8 pt-6 border-t border-white/5 text-center">
          <p className="text-[10px] text-gray-600 uppercase tracking-widest">
            Thayson & Thayla IPTV © 2026 • Premium Experience
          </p>
        </div>
      </motion.div>
    </div>
  );
}
