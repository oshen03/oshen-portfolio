# Use official Nginx Alpine image for a lightweight container
FROM nginx:alpine

# Set maintainer label
LABEL maintainer="oshensathsara2003@gmail.com"
LABEL description="Oshen Sathsara - Professional Portfolio Website"
LABEL version="1.0"

# Remove default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy portfolio files to Nginx html directory
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/

# Copy custom Nginx configuration (optional - for better performance)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
