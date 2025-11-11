# Oshen Sathsara — Portfolio

[![Deployed on Oracle Cloud Infrastructure](https://img.shields.io/badge/Running%20on-Oracle%20Cloud%20Infrastructure-F80000?logo=oracle&logoColor=white)](#)
[![Docker Build](https://img.shields.io/github/actions/workflow/status/oshen03/oshen-portfolio/docker-build.yml?branch=main&label=Docker%20Build&logo=docker&logoColor=white)](https://github.com/oshen03/oshen-portfolio/actions/workflows/docker-build.yml)

Live URL: http://150.230.140.206/

A clean, fast, no‑framework personal site: plain HTML/CSS/JS, Nginx, Docker, dropped onto an OCI VM that politely serves packets all day.

## Highlights
- Static assets + Nginx (Alpine) = low drama
- Dockerized for one‑command local spin‑up
- Shape: VM.Standard.E2.1 (upgraded from VM.Standard.E2.1.Micro after sudo dnf update was OOM-killed)

## Local Run

Docker Compose (recommended):
```powershell
docker compose up -d --build
# Visit http://localhost:8080
```

Windows helper:
```powershell
./deploy.ps1
```

## Notable Files
- Dockerfile — builds lean Nginx image
- nginx.conf — gzip, caching, headers
- docker-compose.yml — port 8080 → 80
- deploy.ps1 / deploy.sh — shortcut scripts

## Deployment (OCI)
- VM: Oracle Linux 9
- Inbound TCP/80 opened
- Container uses --restart unless-stopped

