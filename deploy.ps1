# Portfolio Docker Deployment Script (PowerShell)
# Author: Oshen Sathsara
# Description: Quick deployment script for portfolio website on Windows

# Configuration
$ImageName = "oshen-portfolio"
$ContainerName = "oshen-portfolio"
$Port = "8080"

# Functions
function Write-Header {
   
    Write-Host "  --Portfolio Docker Deployment--" -ForegroundColor Blue
    Write-Host ""
}

function Write-Success {
    param($Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param($Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning {
    param($Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param($Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Test-Docker {
    if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Error "Docker is not installed!"
        Write-Info "Please install Docker Desktop: https://www.docker.com/products/docker-desktop"
        exit 1
    }
    
    # Test if Docker daemon is running
    try {
        docker ps | Out-Null
        Write-Success "Docker is installed and running"
    }
    catch {
        Write-Error "Docker is installed but not running!"
        Write-Info "Please start Docker Desktop and try again"
        exit 1
    }
}

function Stop-ExistingContainer {
    $running = docker ps -q -f name=$ContainerName
    if ($running) {
        Write-Warning "Stopping existing container..."
        docker stop $ContainerName | Out-Null
        Write-Success "Container stopped"
    }
}

function Remove-ExistingContainer {
    $exists = docker ps -aq -f name=$ContainerName
    if ($exists) {
        Write-Warning "Removing existing container..."
        docker rm $ContainerName | Out-Null
        Write-Success "Container removed"
    }
}

function Build-Image {
    Write-Info "Building Docker image..."
    docker build -t $ImageName .
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Image built successfully"
    } else {
        Write-Error "Image build failed"
        exit 1
    }
}

function Start-Container {
    Write-Info "Starting container..."
    docker run -d `
        -p ${Port}:80 `
        --name $ContainerName `
        --restart unless-stopped `
        $ImageName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Container started"
    } else {
        Write-Error "Container failed to start"
        exit 1
    }
}

function Show-Status {
    Write-Host ""
    Write-Header
    Write-Success "Portfolio is now running!"
    Write-Host ""
    Write-Info "Access your portfolio at:"
    Write-Host "  http://localhost:$Port" -ForegroundColor Green
    Write-Host ""
    Write-Info "Useful commands:"
    Write-Host "  docker logs $ContainerName          # View logs"
    Write-Host "  docker stop $ContainerName          # Stop container"
    Write-Host "  docker start $ContainerName         # Start container"
    Write-Host "  docker restart $ContainerName       # Restart container"
    Write-Host ""
}

# Main deployment
Write-Header
Test-Docker
Stop-ExistingContainer
Remove-ExistingContainer
Build-Image
Start-Container
Show-Status
