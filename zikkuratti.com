server {
       server_name zikkuratti.com;

       location / {
            root /var/www/tech;
          #  proxy_pass  http://localhost:80;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_buffering off;
           # proxy_protocol: on;
            tcp_nodelay on;
        }

        location /http-bind {
            proxy_pass  http://localhost:5280/http-bind;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_buffering off;
            tcp_nodelay on;
        }

                location /xmpp-websocket {
                        proxy_pass http://localhost:5280/xmpp-websocket;
                        proxy_http_version 1.1;
                        proxy_set_header Connection "Upgrade";
                        proxy_set_header Upgrade $http_upgrade;

                        proxy_set_header Host $host;
                        proxy_set_header X-Forwarded-For $remote_addr;
                        proxy_read_timeout 900s;
                }

                location /register_web {
            proxy_pass  http://localhost:5280/register_web;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_buffering off;
            tcp_nodelay on;
                        auth_basic "Private area";
            auth_basic_user_file /var/www/protect/.htpasswd;

        }


 location /web {
            proxy_pass  http://localhost:5280/conversejs;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_buffering off;
            tcp_nodelay on;
        }
}
