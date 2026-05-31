const fs = require('fs');
const http = require('http');
const path = require('path');

const root = path.resolve(__dirname, '..', 'build', 'web');
const host = '127.0.0.1';
const port = Number(process.env.PORT || 5173);

const contentTypes = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.ico': 'image/x-icon',
  '.wasm': 'application/wasm',
};

http
  .createServer((request, response) => {
    const urlPath = decodeURIComponent(request.url.split('?')[0]);
    const relativePath = urlPath === '/' ? 'index.html' : urlPath.slice(1);
    const filePath = path.resolve(root, relativePath);

    if (!filePath.startsWith(root)) {
      response.writeHead(403);
      response.end('Forbidden');
      return;
    }

    fs.readFile(filePath, (error, data) => {
      if (error) {
        fs.readFile(path.join(root, 'index.html'), (indexError, indexData) => {
          if (indexError) {
            response.writeHead(404);
            response.end('Not found');
            return;
          }

          response.writeHead(200, { 'Content-Type': contentTypes['.html'] });
          response.end(indexData);
        });
        return;
      }

      response.writeHead(200, {
        'Content-Type':
          contentTypes[path.extname(filePath)] || 'application/octet-stream',
      });
      response.end(data);
    });
  })
  .listen(port, host, () => {
    console.log(`Isle Music preview: http://${host}:${port}`);
  });
