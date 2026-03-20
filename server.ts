import express from 'express';
import cors from 'cors';
import path from 'path';
import { createServer as createViteServer } from 'vite';

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Armazenamento temporário de códigos de pareamento
const pairingCodes = new Map<string, any>();

// Proxy para IPTV API
app.get('/proxy/player_api', async (req, res) => {
    const { host, username, password, action, category_id } = req.query;
    if (!host) return res.status(400).send('Host is required');

    const targetUrl = `${host}/player_api.php?username=${username}&password=${password}&action=${action || ''}&category_id=${category_id || ''}`;
    
    try {
        const response = await fetch(targetUrl);
        const data = await response.json();
        res.json(data);
    } catch (error) {
        res.status(500).send('Error proxying request');
    }
});

// Endpoint para gerar código de pareamento
app.get('/api/pair/generate', (req, res) => {
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    pairingCodes.set(code, { status: 'pending', timestamp: Date.now() });
    
    // Expira em 5 minutos
    setTimeout(() => pairingCodes.delete(code), 5 * 60 * 1000);
    
    res.json({ code });
});

// Endpoint para o site de pareamento enviar dados
app.post('/api/pair/connect', (req, res) => {
    const { code, playlistUrl } = req.body;
    if (pairingCodes.has(code)) {
        pairingCodes.set(code, { status: 'connected', playlistUrl, timestamp: Date.now() });
        res.json({ success: true });
    } else {
        res.status(404).json({ success: false, message: 'Código inválido ou expirado' });
    }
});

// Check de status do pareamento (para a TV consultar)
app.get('/api/pair/status/:code', (req, res) => {
    const { code } = req.params;
    const data = pairingCodes.get(code);
    if (data) {
        res.json(data);
    } else {
        res.status(404).json({ message: 'Not found' });
    }
});

async function startServer() {
    // Vite middleware para desenvolvimento (Site de Pareamento)
    if (process.env.NODE_ENV !== "production") {
        const vite = await createViteServer({
            server: { middlewareMode: true },
            appType: "spa",
        });
        app.use(vite.middlewares);
    } else {
        const distPath = path.join(process.cwd(), 'dist');
        app.use(express.static(distPath));
        app.get('*', (req, res) => {
            res.sendFile(path.join(distPath, 'index.html'));
        });
    }

    app.listen(PORT, "0.0.0.0", () => {
        console.log(`Server running on http://localhost:${PORT}`);
    });
}

startServer();
