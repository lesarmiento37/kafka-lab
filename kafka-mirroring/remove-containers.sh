#!/bin/bash

# Ensure the script runs with root privileges or a user with Docker permissions
if ! [ $(id -u) = 0 ] && ! groups | grep -q '\bdocker\b'; then
    echo "Please run this script as root or a user with Docker privileges."
    exit 1
fi

# Function to check for Docker installation
check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker and try again."
        exit 1
    fi
}

# Function to remove unused containers
remove_unused_containers() {
    # Get a list of unused containers (status: exited or created)
    unused_containers=$(docker ps -a --filter "status=exited" --filter "status=created" -q)

    if [ -z "$unused_containers" ]; then
        echo "No unused containers found. Nothing to remove."
    else
        echo "Removing the following unused containers:"
        docker ps -a --filter "status=exited" --filter "status=created"
        
        # Remove the containers and capture any errors
        if docker rm $unused_containers; then
            echo "Successfully removed unused containers."
        else
            echo "Error occurred while removing unused containers."
            exit 1
        fi
    fi
}

# Main script execution
echo "Starting cleanup of unused Docker containers..."
check_docker_installed
remove_unused_containers
echo "Cleanup complete!"
