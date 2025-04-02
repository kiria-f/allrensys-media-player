# Use the official Flutter SDK image with a specific version
FROM cirrusci/flutter:stable

# Create a non-root user
RUN useradd -m -s /bin/bash flutter && \
    chown -R flutter:flutter /sdks/flutter && \
    git config --global --add safe.directory /sdks/flutter

USER flutter

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy the rest of the application
COPY --chown=flutter:flutter . .

# Build the application
RUN flutter build web

# Use a lightweight web server to serve the built application
FROM nginx:alpine

# Copy the built application from the previous stage
COPY --from=0 /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"] 