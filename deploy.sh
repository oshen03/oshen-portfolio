#!/bin/bash

# Portfolio Docker Deployment Script
# Author: Oshen Sathsara
# Description: Quick deployment script for portfolio website

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="oshen-portfolio"
CONTAINER_NAME="oshen-portfolio"
PORT="8080"

# Functions
print_header() {
    
    echo -e "${BLUE}  --Portfolio Docker Deployment--${NC}"
    
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed!"
        print_info "Please install Docker: https://www.docker.com/get-started"
        exit 1
    fi
    print_success "Docker is installed"
}

stop_existing() {
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        print_warning "Stopping existing container..."
        docker stop $CONTAINER_NAME
        print_success "Container stopped"
    fi
}

remove_existing() {
    if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
        print_warning "Removing existing container..."
        docker rm $CONTAINER_NAME
        print_success "Container removed"
    fi
}

build_image() {
    print_info "Building Docker image..."
    docker build -t $IMAGE_NAME .
    print_success "Image built successfully"
}

run_container() {
    print_info "Starting container..."
    docker run -d \
        -p $PORT:80 \
        --name $CONTAINER_NAME \
        --restart unless-stopped \
        $IMAGE_NAME
    print_success "Container started"
}

show_status() {
    echo ""
    print_header
    print_success "Portfolio is now running!"
    echo ""
    print_info "Access your portfolio at:"
    echo -e "  ${GREEN}http://localhost:$PORT${NC}"
    echo ""
    print_info "Useful commands:"
    echo "  docker logs $CONTAINER_NAME          # View logs"
    echo "  docker stop $CONTAINER_NAME          # Stop container"
    echo "  docker start $CONTAINER_NAME         # Start container"
    echo "  docker restart $CONTAINER_NAME       # Restart container"
    echo ""
}

# Main deployment
main() {
    print_header
    
    check_docker
    stop_existing
    remove_existing
    build_image
    run_container
    show_status
}

# Run main function
main
