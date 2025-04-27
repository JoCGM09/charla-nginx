server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/flisol;

        index index.html index.htm index.nginx-debian.html;

        server_name flisol.com;

        location / {
                root /var/www/flisol;
                index index.html;
        }
}
