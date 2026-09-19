# devops-automation-pipeline
Advanced CI/CD pipeline with disaster recovery, automated testing, security scanning, and multi-tier application deployment to Kubernetes
# DevOps Automation Pipeline with Disaster Recovery

[![CI/CD Pipeline](https://github.com/upworkzero3-cyber/devops-automation-pipeline/actions/workflows/cicd-pipeline.yaml/badge.svg)](https://github.com/upworkzero3-cyber/devops-automation-pipeline/actions)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A production-grade **multi-tier application deployment pipeline** demonstrating advanced DevOps practices including:
- **Advanced CI/CD** with GitHub Actions (testing → building → scanning → deploying)
- **Disaster Recovery** with automated backup/restore procedures
- **Security Scanning** (vulnerability scanning, secrets detection, code quality)
- **High Availability** with multi-replica deployments and auto-recovery
- **Infrastructure as Code** for reproducible deployments

---

## 🎯 Quick Overview
Developer Push → GitHub Actions Pipeline → Tests → Build → Security Scan
→ Deploy to Kubernetes → Smoke Tests → Backup → Production

**What Gets Deployed:**
- 🎨 Frontend (React + Nginx, 2 replicas)
- 🔧 Backend API (Node.js, 2 replicas)  
- 🗄️ Database (PostgreSQL)
- 📦 All with health checks, auto-recovery, backups

---

## 📊 Architecture
┌─────────────────────────────────────────────────┐
│ GitHub Repository │
│ (app/, k8s-manifests/, scripts/) │
└──────────────────┬──────────────────────────────┘
│ Push
▼
┌──────────────────────────────────────────────────┐
│ GitHub Actions CI/CD Pipeline │
│ ┌─────────┐ ┌──────┐ ┌──────────┐ ┌────────┐│
│ │ Tests │→ │Build │→ │ Security │→ │ Deploy ││
│ └─────────┘ └──────┘ └──────────┘ └────────┘│
└──────────────────┬───────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────┐
│ Kubernetes Cluster (Docker Desktop) │
│ devops-pipeline namespace │
│ │
│ ┌──────────────┐ ┌──────────────┐ │
│ │ Frontend │ │ Backend │ │
│ │ (2 replicas)│ │ (2 replicas) │ │
│ └──────────────┘ └──────────────┘ │
│ │ │ │
│ └──────────┬───────┘ │
│ ▼ │
│ ┌─────────────────┐ │
│ │ PostgreSQL │ │
│ │ (Database) │ │
│ └─────────────────┘ │
└──────────────────┬───────────────────────────────┘
│

┌──────────┴──────────┐
▼ ▼
┌──────────┐ ┌──────────┐
│ Backups │ │ Smoke │
│ (DR) │ │ Tests │
└──────────┘ └──────────┘

---

## 🚀 Features

### 1. Advanced CI/CD Pipeline
- ✅ **Testing** - Automated tests on every commit
- ✅ **Building** - Docker image creation with BuildKit
- ✅ **Security Scanning** - Trivy vulnerability scanning, secret detection
- ✅ **Code Quality** - Linting and SAST analysis
- ✅ **Deployment** - Automated rollout to Kubernetes
- ✅ **Post-Deploy Tests** - Smoke tests verify application health
- ✅ **Backup** - Automatic cluster state backup after successful deploy

### 2. Disaster Recovery
- ✅ **Automated Backups** - Daily cluster state snapshots
- ✅ **One-Command Restore** - Full cluster recovery from backup
- ✅ **Failover Testing** - Automated chaos testing
- ✅ **Backup Verification** - SHA256 checksums for integrity
- ✅ **Recovery Documentation** - Runbooks for manual recovery

### 3. High Availability
- ✅ **Multi-Replica Deployments** - 2+ replicas per service
- ✅ **Pod Anti-Affinity** - Spread across nodes
- ✅ **Health Checks** - Liveness & readiness probes
- ✅ **Auto-Recovery** - Kubernetes restarts failed pods
- ✅ **Load Balancing** - Service-level load distribution

### 4. Security
- ✅ **Container Scanning** - Trivy detects vulnerabilities
- ✅ **Secret Detection** - GitLeaks prevents credential commits
- ✅ **RBAC** - Kubernetes role-based access control (future)
- ✅ **Secret Management** - Kubernetes Secrets (encrypted by default)
- ✅ **Network Policies** - Pod-to-pod traffic control (future)

---

## 📁 Project Structure
devops-automation-pipeline/
├── app/ # Application code
│ ├── frontend/ # React frontend + Nginx
│ │ ├── index.html # Single-page application
│ │ ├── nginx.conf # Nginx reverse proxy config
│ │ └── Dockerfile # Container image definition
│ ├── backend/ # Node.js API server
│ │ ├── server.js # Express.js API
│ │ ├── package.json # Dependencies
│ │ ├── Dockerfile # Container image definition
│ │ └── .dockerignore # Exclude files from image
│ └── database/ # Database scripts
│ └── init.sql # PostgreSQL initialization
├── k8s-manifests/ # Kubernetes manifests
│ ├── namespace.yaml # Namespace definition
│ ├── postgres.yaml # Database deployment
│ ├── backend.yaml # Backend deployment
│ └── frontend.yaml # Frontend deployment
├── scripts/ # Automation scripts
│ ├── backup/ # Disaster Recovery
│ │ └── backup.sh # Automated backup script
│ └── recovery/ # Disaster Recovery
│ ├── restore.sh # Cluster restore script
│ └── failover-test.sh # Chaos testing script
├── .github/ # GitHub configuration
│ └── workflows/
│ └── cicd-pipeline.yaml # GitHub Actions workflow
├── docs/ # Documentation
│ ├── SETUP.md # Local setup guide
│ ├── ARCHITECTURE.md # System design
│ ├── CICD.md # Pipeline explanation
│ └── DR.md # Disaster recovery guide
├── README.md # This file
└── LICENSE # MIT License

---

## ⚡ Quick Start (15 minutes)

### Prerequisites
- Docker Desktop (with Kubernetes enabled)
- kubectl installed
- Git

### Step 1: Clone Repository
```bash
git clone https://github.com/upworkzero3-cyber/devops-automation-pipeline.git
cd devops-automation-pipeline
```

### Step 2: Enable Kubernetes
1. Open Docker Desktop → Settings → Kubernetes
2. Enable Kubernetes
3. Wait 2-3 minutes for startup

### Step 3: Build Docker Images
```bash
# Backend
cd app/backend
docker build -t backend:latest .

# Frontend
cd ../frontend
docker build -t frontend:latest .

cd ../..
```

### Step 4: Deploy to Kubernetes
```bash
# Create namespace and deploy
kubectl create namespace devops-pipeline
kubectl apply -f k8s-manifests/

# Wait for pods to start
kubectl get pods -n devops-pipeline -w
```

### Step 5: Access Application
```bash
# Port-forward frontend
kubectl port-forward -n devops-pipeline svc/frontend 8080:80 &

# Open browser
open http://localhost:8080
```

### Step 6: Test the Application
1. Go to http://localhost:8080
2. Add a user in the form
3. Watch the frontend communicate with backend + database
4. Check "Status" cards for health

---

## 🔄 CI/CD Pipeline Stages

| Stage | Purpose | Tools |
|-------|---------|-------|
| **1. Test** | Run automated tests | npm test |
| **2. Build** | Create Docker images | Docker BuildKit |
| **3. Security** | Scan vulnerabilities | Trivy, GitLeaks, SonarQube |
| **4. Deploy** | Push to Kubernetes | kubectl |
| **5. Smoke Tests** | Verify deployment | curl, wget |
| **6. Backup** | Create recovery backup | kubectl export |

**Trigger:** Push to `main` or `develop` branch

---

## 🛡️ Disaster Recovery

### Automated Backup
```bash
# Runs automatically after every successful deployment
# Creates: backups/YYYY-MM-DD-HH-MM-SS/
```

### Manual Backup
```bash
bash scripts/backup/backup.sh
```

### Restore from Backup
```bash
bash scripts/recovery/restore.sh backups/2026-09-18-12-30-45
```

### Failover Testing
```bash
bash scripts/recovery/failover-test.sh
```

This tests:
- Pod failure and auto-recovery
- Service connectivity
- Database resilience
- Multi-replica availability
- Namespace isolation

---

## 📊 Monitoring & Logs

### View Logs
```bash
# Frontend logs
kubectl logs -n devops-pipeline -l app=frontend -f

# Backend logs
kubectl logs -n devops-pipeline -l app=backend -f

# Database logs
kubectl logs -n devops-pipeline -l app=postgres -f
```

### Check Pod Status
```bash
kubectl get pods -n devops-pipeline -o wide
kubectl describe pod <pod-name> -n devops-pipeline
```

### Check Events
```bash
kubectl get events -n devops-pipeline --sort-by='.lastTimestamp'
```

---

## 🔒 Security Practices Implemented

✅ **Container Scanning** - Trivy checks for vulnerabilities  
✅ **Secret Detection** - GitLeaks prevents credential commits  
✅ **Linting** - Code quality checks  
✅ **SAST** - Static code analysis  
✅ **Health Checks** - Liveness & readiness probes  
✅ **Pod Limits** - Resource constraints  
✅ **RBAC** - Role-based access (expandable)  

---

## 📚 Documentation

- [**SETUP.md**](./docs/SETUP.md) - Complete local setup guide
- [**ARCHITECTURE.md**](./docs/ARCHITECTURE.md) - System design & diagrams
- [**CICD.md**](./docs/CICD.md) - Pipeline deep-dive
- [**DR.md**](./docs/DR.md) - Disaster recovery procedures

---

## 🎓 What This Demonstrates

✅ **Production-Grade CI/CD** - Full automated pipeline  
✅ **Kubernetes Expertise** - Multi-tier deployments  
✅ **Disaster Recovery** - Real backup/restore procedures  
✅ **Security-First** - Vulnerability scanning & secret detection  
✅ **High Availability** - Multi-replica, auto-recovery  
✅ **Infrastructure as Code** - Declarative, reproducible setup  
✅ **DevOps Best Practices** - Industry-standard approach  

---

## 🚀 Technologies Used

- **Container Orchestration:** Kubernetes
- **CI/CD:** GitHub Actions
- **Container Runtime:** Docker
- **Infrastructure:** Docker Desktop K8s / Kind
- **Frontend:** HTML/CSS/JavaScript + Nginx
- **Backend:** Node.js + Express.js
- **Database:** PostgreSQL
- **Security:** Trivy, GitLeaks, SonarQube
- **Scripting:** Bash

---

## 📈 Career Impact

This project demonstrates:
- 🎯 Real production DevOps knowledge
- 🎯 End-to-end CI/CD pipeline design
- 🎯 Disaster recovery planning & testing
- 🎯 Security-focused infrastructure
- 🎯 High availability architecture
- 🎯 Infrastructure automation

**Perfect for:** DevOps Engineer, Platform Engineer, SRE roles

---

## 📝 License

MIT License - See [LICENSE](LICENSE) for details

---

## 👤 Author

**Farrukh Samran**  
GitHub: [@upworkzero3-cyber](https://github.com/upworkzero3-cyber)

---

**⭐ If this project helps you, please star the repo!**
