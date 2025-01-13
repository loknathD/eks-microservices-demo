# Dockerfile
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Create non-root user
RUN adduser -D -u 1000 nodeuser && \
    chown -R nodeuser:nodeuser /app

# Switch to non-root user
USER nodeuser

# Expose application port
EXPOSE 3000

# Start application
CMD ["node", "app.js"]