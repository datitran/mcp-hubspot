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

# Expose ports
EXPOSE 8000

ENV HUBSPOT_ACCESS_TOKEN=pat-na1-4899999999999999999999999999999999999999999999999999999999999999

# Start nginx and the HubSpot server
CMD nginx && npx -y supergateway --stdio "mcp-server-hubspot" --port 5000