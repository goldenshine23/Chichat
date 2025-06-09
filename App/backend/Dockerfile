# Use an official Node.js runtime as a parent image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install dependencies first (utilizes Docker cache efficiently)
COPY package*.json ./
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 5000

# Start the application
CMD ["node", "server.js"]
