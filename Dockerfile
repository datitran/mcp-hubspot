# Use Python base image
FROM python:3.10-slim-bookworm

# Install Node.js
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install the project into `/app`
WORKDIR /app

# Copy the entire project
COPY . /app

# Install the package
RUN pip install --no-cache-dir .

EXPOSE 5000

# Run the server
ENTRYPOINT ["npx", "-y", "supergateway", "--stdio", "mcp-server-hubspot", " --port", "5000"]