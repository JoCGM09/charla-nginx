const http = require('http');
const PORT = process.env.PORT || 3000;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`Hola desde Node en el puerto ${PORT}\n`);
}).listen(PORT, () => {
  console.log(`Servidor en puerto ${PORT}`);
});
