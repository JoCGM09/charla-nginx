######## 1. SERVIR UNA PÁGINA ESTÁTICA ########

### Actualización de paquetes

sudo apt update
sudo apt install nginx nodejs npm -y

### Crear un archivo HTML

cd /var/www
sudo mkdir flisol
cd flisol
sudo mkdir index.html
vi index.html
### Añadir el archivo HTML ###

### Modificar el archivo de configuración de sites-available
sudo vi /etc/nginx/sites-available/default

### Copiar el archivo default y crear dos nuevos
cp default flisol.com

### Modificar cada uno de los archivos
vi flisol.com
### Añadir el archivo flisol.com ###


### Pasar los archivos a sites-enabled mediante link simbólico
cd /etc/nginx/sites-available
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/flisol.com .

### Probar que las configuraciones son correctas
sudo nginx -t
### Reiniciar el servicio de Nginx
sudo systemctl reload nginx

### Buscar en tu navegador localhost y verificar que la página estática esté activa

######## 2. CREAR UN PROXY INVERSO ########
sudo mkdir -p ~/web-node1
cd ~/web-node1
sudo vi index.js

### Instalar PM2 para correr nodejs como servicio en segundo plano
sudo npm install pm2 -g

### Iniciar el servicio de nodejs con 3 nodos
PORT=3000 pm2 start index.js --name node1
PORT=3001 pm2 start index.js --name node2
PORT=3002 pm2 start index.js --name node3

### Nota: el proceso se detiene con pm2 stop node1,2 y 3
 
### Configurar nginx como proxy inverso y balanceador de carga 
sudo vi /etc/nginx/sites-available/flisol.com
sudo truncate -s 0 flisol1.com
### Añadir el archivo flisol-proxy ###

### Verificar la configuración de nginx y cargar
sudo nginx -t
sudo systemctl reload nginx

### Buscar en tu navegador localhost y recargarla para verificar el balanceo de carga

######## 3. CREAR UN CERTIFICADO SSL ########

### Instalar mkcert
sudo apt install libnss3-tools -y
sudo wget https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v1.4.4-linux-amd64
sudo mv mkcert-v1.4.4-linux-amd64 /usr/local/bin/mkcert
sudo chmod +x /usr/local/bin/mkcert

### Instalar el certificado raíz
mkcert -install

### Mueve los certificados a la carpeta de nginx
sudo mkdir -p /etc/nginx/ssl
sudo mv localhost+2.pem /etc/nginx/ssl/localhost.crt
sudo mv localhost+2-key.pem /etc/nginx/ssl/localhost.key

### Configuración de nginx para usar el certificado
sudo vi /etc/nginx/sites-available/flisol1.com
### Agregar el archivo flisol-proxy-ssl ###

### Habilitar el sitio y recargar nginx
sudo nginx -t
sudo systemctl reload nginx

### Ingresa a localhost:443 y verifica que el certificado esté activo
