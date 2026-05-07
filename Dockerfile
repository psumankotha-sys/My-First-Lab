FROM nginx:alpine

# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*

# Create custom HTML page
RUN echo '<html><head><title>Suman DevOps</title></head><body style="font-family:Arial; text-align:center; padding:50px; background:#1a1a2e;"><h1 style="color:#00d4ff">Suman DevOps</h1><p style="color:white">Welcome to Docker + DevOps Project</p></body></html>' > /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]