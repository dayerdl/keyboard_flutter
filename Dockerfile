# Use Flutter stable image
FROM ghcr.io/cirruslabs/flutter:stable

# Set working directory
WORKDIR /app

# Copy everything into the container
COPY . .

# Enable web and build
RUN flutter config --enable-web
RUN flutter build web

# Required by Vercel – this triggers the static build output
CMD ["vercel-build"]
