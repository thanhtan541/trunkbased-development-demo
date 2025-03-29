# Stage 1: Build Stage
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if it exists)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vite app for production
RUN npm run build

# Use an official Nginx image to serve the React app
FROM nginx:alpine

# Copy the build folder from React app to the Nginx HTML folder
COPY --from=builder /app/dist /usr/share/nginx/html/
# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
