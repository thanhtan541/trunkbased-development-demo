# Use an official Nginx image to serve the React app
FROM nginx:alpine

# Copy the build folder from React app to the Nginx HTML folder
COPY dist/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
