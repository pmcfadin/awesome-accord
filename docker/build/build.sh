#!/bin/bash

set -e  # Exit on error

# Check for cassandra directory
if [ ! -d "cassandra" ]; then
    echo "Error: cassandra directory not found"
    echo "Please checkout and build the Cassandra Accord branch first"
    exit 1
fi

# Build Docker image
echo "Building Docker image..."
docker build -t cassandra-accord .

echo "Build completed successfully!"
echo "Run: docker run -d --name cassandra-accord -p 9042:9042 cassandra-accord"