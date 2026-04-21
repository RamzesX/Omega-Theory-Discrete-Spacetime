#!/usr/bin/env node
/**
 * Minimal static server for `site/dist/` — Playwright webServer target.
 *
 * Serves the built Astro site under the `/Omega-Theory-Discrete-Spacetime` base path exactly
 * like GitHub Pages does. No dependencies (just `node:http` + `node:fs`).
 *
 * Why not `astro preview`? On some WSL setups Astro's preview server exits
 * with signal 144 shortly after start (undiagnosed; likely a TTY or
 * file-watching issue with /mnt/c paths). This server avoids that whole
 * class of problems by being ~40 lines of plain Node.
 *
 * Run directly:        node scripts/static-server.mjs
 * Or custom port:      PORT=5173 node scripts/static-server.mjs
 * Or custom base:      BASE_PATH=/foo node scripts/static-server.mjs
 */
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import url from 'node:url';

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));
const DIST = path.resolve(__dirname, '..', 'dist');
const PORT = Number(process.env.PORT) || 4321;
const BASE_PATH = process.env.BASE_PATH || '/Omega-Theory-Discrete-Spacetime';

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.mjs': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.woff2': 'font/woff2',
  '.woff': 'font/woff',
  '.ico': 'image/x-icon',
  '.txt': 'text/plain; charset=utf-8',
  '.xml': 'application/xml',
};

if (!fs.existsSync(DIST)) {
  console.error(`dist/ not found at ${DIST} — run \`npm run build\` first`);
  process.exit(1);
}

const server = http.createServer((req, res) => {
  let p = req.url.split('?')[0];

  // Normalise base prefix — both exact ("/Omega-Theory-Discrete-Spacetime") and subpath
  if (p === BASE_PATH) p = '/';
  else if (p.startsWith(BASE_PATH + '/')) p = p.slice(BASE_PATH.length);

  // Directory → index.html
  if (p.endsWith('/')) p += 'index.html';

  const filePath = path.join(DIST, p);
  // Security: reject paths escaping dist/
  if (!filePath.startsWith(DIST)) {
    res.writeHead(403); res.end('403'); return;
  }

  if (!fs.existsSync(filePath) || !fs.statSync(filePath).isFile()) {
    // Try 404.html as fallback (Astro emits one)
    const notFound = path.join(DIST, '404.html');
    if (fs.existsSync(notFound)) {
      res.writeHead(404, { 'Content-Type': MIME['.html'] });
      fs.createReadStream(notFound).pipe(res);
    } else {
      res.writeHead(404); res.end('404');
    }
    return;
  }

  const ext = path.extname(filePath).toLowerCase();
  res.writeHead(200, {
    'Content-Type': MIME[ext] || 'application/octet-stream',
    'Cache-Control': 'no-cache',
  });
  fs.createReadStream(filePath).pipe(res);
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`static-server: http://127.0.0.1:${PORT}${BASE_PATH}/`);
});

// Graceful shutdown
['SIGINT', 'SIGTERM'].forEach((sig) =>
  process.on(sig, () => {
    server.close(() => process.exit(0));
  })
);
