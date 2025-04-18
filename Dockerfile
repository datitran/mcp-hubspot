# Use Python base image
FROM python:3.10-slim-bookworm

# Install Node.js & nginx
RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    apache2-utils \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install the project into `/app`
WORKDIR /app

# Copy the entire project
COPY . /app

# Install the package
RUN pip install --no-cache-dir .

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create password file (replace 'password' with your desired password)
RUN htpasswd -bc /etc/nginx/.htpasswd dat test1234

# Create log directories
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log && \
    chown -R www-data:www-data /var/log/nginx

# Expose ports
EXPOSE 8000 5000

# Start nginx and the HubSpot server
CMD nginx && npx -y supergateway --stdio "mcp-server-hubspot" --port 5000