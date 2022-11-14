server {
    listen 80;
    server_name  orange.sp-lutsk.com;
    location / {
    	return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name  orange.sp-lutsk.com;
    ssl_certificate /etc/nginx/certs/orangehrm.crt;
    ssl_certificate_key /etc/nginx/certs/orangehrm.key;
    
    location / {
        proxy_pass http://orangehrm:80/;
	proxy_set_header Host $host;
    	proxy_set_header X-Real-IP $remote_addr;
    	proxy_set_header Accept-Encoding "";
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;	
    }
}
