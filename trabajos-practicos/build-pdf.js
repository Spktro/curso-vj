#!/usr/bin/env node
/*
 * build-pdf.js — convierte un Trabajo Práctico (Markdown) a PDF.
 *
 * Genera un HTML con el estilo del curso y lo imprime a PDF con
 * Chrome o Edge en modo headless (detecta el navegador solo).
 *
 * Uso:
 *   npm install                 # una sola vez (instala 'marked')
 *   node build-pdf.js trabajo-practico-4.md
 *   node build-pdf.js trabajo-practico-4.md salida.pdf
 *
 * Si el navegador está en una ruta rara, pasalo por variable de entorno:
 *   CHROME_PATH="C:/ruta/chrome.exe" node build-pdf.js archivo.md
 */

const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');
const { marked } = require('marked');

// ---- argumentos ----
const inMd = process.argv[2];
if (!inMd) {
  console.error('Uso: node build-pdf.js <archivo.md> [salida.pdf]');
  process.exit(1);
}
const outPdf = process.argv[3] || inMd.replace(/\.md$/i, '') + '.pdf';

// ---- markdown -> html ----
marked.setOptions({ gfm: true, breaks: false });
let body = marked.parse(fs.readFileSync(inMd, 'utf8'));
body = body.replace(/<details>/g, '<details open>'); // que el troubleshooting salga abierto en el PDF

const css = `
:root{--accent:#7c3aed;--accent-2:#2563eb;--text:#1b2230;--muted:#5a6576;
--border:#d9dee8;--panel:#fff;--panel-2:#eef0f5;--code-bg:#f6f8fa;--green:#15803d;--red:#dc2626;--yellow:#b45309;}
*{box-sizing:border-box}
html{-webkit-print-color-adjust:exact;print-color-adjust:exact}
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,"Segoe UI Emoji",sans-serif;
color:var(--text);line-height:1.55;font-size:14.5px;max-width:820px;margin:0 auto;padding:8px 4px 40px}
h1{font-size:30px;font-weight:800;letter-spacing:-.01em;margin:0 0 6px;line-height:1.15}
h2{font-size:21px;font-weight:800;margin:30px 0 12px;padding-bottom:6px;border-bottom:2px solid var(--border);break-after:avoid}
h3{font-size:16.5px;font-weight:700;color:var(--accent);margin:20px 0 8px;break-after:avoid}
h4{font-size:14.5px;font-weight:700;margin:16px 0 6px}
p{margin:9px 0}a{color:var(--accent-2);text-decoration:none}strong{font-weight:700}
code{font-family:"SF Mono",Menlo,Consolas,monospace;font-size:.86em;background:var(--panel-2);color:var(--accent-2);padding:1px 6px;border-radius:4px}
pre{background:var(--code-bg);border:1px solid var(--border);border-radius:10px;padding:14px 16px;overflow:auto;break-inside:avoid}
pre code{background:none;color:#24292f;padding:0;font-size:12.5px;line-height:1.5}
ul,ol{margin:8px 0;padding-left:26px}li{margin:5px 0}li::marker{color:var(--accent);font-weight:700}
img{max-width:100%;height:auto;display:block;margin:12px 0;border:1px solid var(--border);border-radius:8px;break-inside:avoid}
hr{border:none;border-top:1px solid var(--border);margin:26px 0}
blockquote{margin:12px 0;background:rgba(124,58,237,.06);border-left:3px solid var(--accent);padding:10px 16px;border-radius:0 8px 8px 0;break-inside:avoid}
blockquote p{margin:5px 0;font-size:13.8px}
table{width:100%;border-collapse:collapse;margin:14px 0;font-size:13.2px;border:1px solid var(--border);border-radius:8px;overflow:hidden;break-inside:avoid}
th,td{text-align:left;padding:9px 12px;border-bottom:1px solid var(--border);vertical-align:top}
th{background:var(--panel-2);color:var(--muted);font-weight:700;text-transform:uppercase;font-size:11px;letter-spacing:.06em}
tr:last-child td{border-bottom:none}td code,th code{background:var(--panel-2)}
details{margin:12px 0;border:1px solid var(--border);border-radius:8px;padding:8px 14px;background:var(--panel);break-inside:avoid}
summary{font-weight:700;color:var(--muted);margin:-2px 0 4px}
input[type=checkbox]{width:14px;height:14px;margin-right:6px;accent-color:var(--accent)}
li:has(input[type=checkbox]){list-style:none;margin-left:-20px}
@page{size:A4;margin:15mm 14mm}
`;

const html = `<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<title>${path.basename(inMd, '.md')}</title><style>${css}</style></head><body>
${body}
</body></html>`;

const tmpHtml = path.join(os.tmpdir(), 'tp-' + path.basename(inMd, '.md') + '.html');
fs.writeFileSync(tmpHtml, html, 'utf8');

// ---- encontrar Chrome / Edge ----
function findBrowser() {
  if (process.env.CHROME_PATH && fs.existsSync(process.env.CHROME_PATH)) return process.env.CHROME_PATH;
  const candidates = [
    'C:/Program Files/Google/Chrome/Application/chrome.exe',
    'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
    'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    '/usr/bin/google-chrome',
    '/usr/bin/chromium',
    '/usr/bin/chromium-browser',
  ];
  return candidates.find(p => fs.existsSync(p)) || null;
}

const browser = findBrowser();
if (!browser) {
  console.error('No encontré Chrome ni Edge. Pasá la ruta con CHROME_PATH=...');
  console.error('El HTML quedó en: ' + tmpHtml);
  process.exit(1);
}

// ruta -> file URL (Windows: C:/x -> file:///C:/x)
const fileUrl = 'file:///' + path.resolve(tmpHtml).replace(/\\/g, '/');

execFileSync(browser, [
  '--headless=new', '--disable-gpu', '--no-pdf-header-footer',
  '--virtual-time-budget=25000', '--run-all-compositor-stages-before-draw',
  '--print-to-pdf=' + path.resolve(outPdf), fileUrl,
], { stdio: 'ignore' });

fs.unlinkSync(tmpHtml);
const kb = Math.round(fs.statSync(outPdf).size / 1024);
console.log(`PDF generado: ${outPdf} (${kb} KB)`);
