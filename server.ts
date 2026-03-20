import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import axios from "axios";
import { v4 as uuidv4 } from "uuid";
import path from "path";
import { createServer as createViteServer } from "vite";

const app = express();
app.use(cors());
app.use(bodyParser.json());

// In-memory store for pairing codes (code -> { status, credentials })
const sessions: Record<string, { status: string; credentials?: any; expires: number }> = {};

// 1. Generate Pairing Code
app.get("/api/pair/generate", (req, res) => {
  const code = Math.floor(100000 + Math.random() * 900000).toString();
  sessions[code] = { status: "pending", expires: Date.now() + 10 * 60 * 1000 }; // 10 mins
  res.json({ code });
});

// 2. Check Pairing Status (Polling from Roku)
app.get("/api/pair/status/:code", (req, res) => {
  const session = sessions[req.params.code];
  if (!session) return res.status(404).json({ error: "Code not found or expired" });
  res.json(session);
});

// 3. Submit Credentials (from Web Browser)
app.post("/api/pair/submit", (req, res) => {
  const { code, host, username, password } = req.body;
  if (!sessions[code]) return res.status(404).json({ error: "Invalid code" });
  
  sessions[code] = {
    status: "completed",
    credentials: { host, username, password },
    expires: Date.now() + 5 * 60 * 1000
  };
  res.json({ success: true });
});

// 4. IPTV Proxy to avoid CORS
app.get("/api/proxy", async (req, res) => {
  const { url } = req.query;
  if (!url) return res.status(400).send("URL required");
  
  try {
    const response = await axios.get(url as string, {
      responseType: "stream",
      headers: { "User-Agent": "Mozilla/5.0" }
    });
    response.data.pipe(res);
  } catch (error: any) {
    res.status(500).send(error.message);
  }
});

async function startServer() {
  const PORT = 3000;

  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
  });
}

startServer();
