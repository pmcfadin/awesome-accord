#!/bin/bash

echo "Setting up banking transaction examples..."

# Check if Cassandra is running
if ! docker ps | grep -q cassandra-accord; then
    echo "Starting Cassandra container..."
    docker run -d --name cassandra-accord -p 9042:9042 pmcfadin/cassandra-accord
    
    # Wait for Cassandra to be ready
    echo "Waiting for Cassandra to start..."
    while ! docker exec cassandra-accord ./bin/cqlsh -e "describe keyspaces" > /dev/null 2>&1; do
        sleep 2
    done
fi

# Create schema
echo "Creating schema..."
docker exec -i cassandra-accord ./bin/cqlsh < schemas.cql

# Load sample data
echo "Loading sample data..."
docker exec -i cassandra-accord ./bin/cqlsh < sample_data.cql

echo "Setup complete! Running verification..."

# Verify setup
docker exec -i cassandra-accord ./bin/cqlsh -e "
SELECT account_holder, account_balance 
FROM banking.accounts;"

echo ""
echo "Setup complete! You can now run transfers using:"
echo "docker exec -i cassandra-accord ./bin/cqlsh < transfer.cql"