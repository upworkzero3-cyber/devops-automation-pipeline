# Local Setup Guide

Complete step-by-step guide to deploy the DevOps pipeline locally.

## Prerequisites

- **Docker Desktop** (Mac/Windows/Linux)
  - Download: https://www.docker.com/products/docker-desktop
  - Version: 4.0+
  
- **kubectl** (Kubernetes CLI)
```bash
  # Mac
  brew install kubectl
  
  # Windows (PowerShell)
  choco install kubernetes-cli
  
  # Linux
  sudo apt-get install kubectl
```

- **Git**
```bash
  git --version  # Verify installation
```

- **System Requirements**
  - RAM: 8GB minimum (4GB for Docker, 4GB for Kubernetes)
  - Disk: 20GB free
  - CPU: 4 cores minimum

---

## Step 1: Enable Kubernetes in Docker Desktop

### Mac/Windows

1. Open **Docker Desktop**
2. Go to **Settings** (Gear icon, top right)
3. Click **Kubernetes** in left sidebar
4. Check **"Enable Kubernetes"**
5. Click **"Apply & Restart"**
6. Wait 3-5 minutes for Kubernetes to start

### Verify Installation

```bash
kubectl cluster-info
kubectl get nodes
```

Expected output: