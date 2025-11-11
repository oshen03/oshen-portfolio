# Makefile for Portfolio Docker Management
# Usage: make <target>

.PHONY: help build run stop restart logs clean deploy test

# Variables
IMAGE_NAME := oshen-portfolio
CONTAINER_NAME := oshen-portfolio
PORT := 8080

# Default target
.DEFAULT_GOAL := help

# Help target
help: ## Show this help message
	@echo "Portfolio Docker Management"
	@echo "==========================="
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Build image
build: ## Build the Docker image
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME) .
	@echo "✓ Build complete!"

# Run container
run: ## Run the container (detached)
	@echo "Starting container..."
	docker run -d -p $(PORT):80 --name $(CONTAINER_NAME) --restart unless-stopped $(IMAGE_NAME)
	@echo "✓ Container started!"
	@echo "Access at: http://localhost:$(PORT)"

# Start existing container
start: ## Start existing container
	@echo "Starting container..."
	docker start $(CONTAINER_NAME)
	@echo "✓ Container started!"

# Stop container
stop: ## Stop the container
	@echo "Stopping container..."
	docker stop $(CONTAINER_NAME)
	@echo "✓ Container stopped!"

# Restart container
restart: ## Restart the container
	@echo "Restarting container..."
	docker restart $(CONTAINER_NAME)
	@echo "✓ Container restarted!"

# View logs
logs: ## View container logs (follow mode)
	docker logs -f $(CONTAINER_NAME)

# View logs (last 50 lines)
logs-tail: ## View last 50 lines of logs
	docker logs --tail=50 $(CONTAINER_NAME)

# Remove container
rm: ## Remove the container
	@echo "Removing container..."
	docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@echo "✓ Container removed!"

# Remove image
rmi: ## Remove the image
	@echo "Removing image..."
	docker rmi $(IMAGE_NAME) 2>/dev/null || true
	@echo "✓ Image removed!"

# Clean everything
clean: rm rmi ## Remove container and image
	@echo "✓ Cleanup complete!"

# Full deploy (stop, build, run)
deploy: stop rm build run ## Full deployment (stop, remove, build, run)
	@echo "✓ Deployment complete!"

# Quick restart (for code changes)
redeploy: ## Quick redeploy with rebuild
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@docker build -t $(IMAGE_NAME) .
	@docker run -d -p $(PORT):80 --name $(CONTAINER_NAME) --restart unless-stopped $(IMAGE_NAME)
	@echo "✓ Redeployment complete!"
	@echo "Access at: http://localhost:$(PORT)"

# Docker Compose commands
up: ## Start with docker-compose
	docker-compose up -d
	@echo "✓ Services started!"
	@echo "Access at: http://localhost:$(PORT)"

down: ## Stop with docker-compose
	docker-compose down
	@echo "✓ Services stopped!"

up-build: ## Start with docker-compose (rebuild)
	docker-compose up -d --build
	@echo "✓ Services started with rebuild!"

# Container shell access
shell: ## Open shell in running container
	docker exec -it $(CONTAINER_NAME) /bin/sh

# Check container status
status: ## Show container status
	@echo "Container status:"
	@docker ps -a --filter name=$(CONTAINER_NAME) --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check container health
health: ## Check container health
	@docker inspect --format='{{.State.Health.Status}}' $(CONTAINER_NAME) 2>/dev/null || echo "Health check not available"

# View container stats
stats: ## View container resource usage
	docker stats $(CONTAINER_NAME) --no-stream

# Test if website is accessible
test: ## Test if website is responding
	@echo "Testing website..."
	@curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:$(PORT) || echo "✗ Website not accessible"

# Open in browser (Windows)
open: ## Open portfolio in default browser
	@cmd.exe /c start http://localhost:$(PORT)

# Docker cleanup
prune: ## Clean up unused Docker resources
	docker system prune -f
	@echo "✓ Docker cleanup complete!"

# Show image size
size: ## Show Docker image size
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Export image
export: ## Export image to tar file
	docker save $(IMAGE_NAME) > oshen-portfolio.tar
	@echo "✓ Image exported to oshen-portfolio.tar"

# Import image
import: ## Import image from tar file
	docker load < oshen-portfolio.tar
	@echo "✓ Image imported from oshen-portfolio.tar"

# Push to Docker Hub
push: ## Push image to Docker Hub
	@read -p "Enter Docker Hub username: " username; \
	docker tag $(IMAGE_NAME) $$username/$(IMAGE_NAME):latest; \
	docker push $$username/$(IMAGE_NAME):latest
	@echo "✓ Image pushed to Docker Hub!"

# Development mode (with volume mount)
dev: ## Run in development mode with volume mount
	docker run -d -p $(PORT):80 \
		--name $(CONTAINER_NAME)-dev \
		-v $$(pwd)/index.html:/usr/share/nginx/html/index.html \
		-v $$(pwd)/styles.css:/usr/share/nginx/html/styles.css \
		-v $$(pwd)/assets:/usr/share/nginx/html/assets \
		$(IMAGE_NAME)
	@echo "✓ Development container started!"
	@echo "Changes to files will be reflected immediately"
