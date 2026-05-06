# Base image - lightweight Linux
FROM ubuntu:22.04

# Who made this
LABEL maintainer="psumankotha-sys"

# Update packages
RUN apt-get update && apt-get install -y curl

# Create a working directory
WORKDIR /app

# Copy all files from your project into container
COPY . .

# Command to run when container starts
CMD ["sh", "-c", "echo 'running'; sleep infinity"]