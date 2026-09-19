#!/bin/bash

# Disaster Recovery - Restore Script
# Usage: ./restore.sh <backup-directory>

set -e

BACKUP_DIR="${1:-.}"
NAMESPACE="devops-pipeline"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Backup directory not found: $BACKUP_DIR"
    exit 1
fi

echo "🚨 Starting Kubernetes Cluster Restore"
echo "Backup: $BACKUP_DIR"
echo "Target Namespace: $NAMESPACE"
echo ""

# Verify backup integrity
if [ -f "$BACKUP_DIR/CHECKSUM" ]; then
    echo "🔐 Verifying backup integrity..."
    cd "$BACKUP_DIR"
    if sha256sum -c CHECKSUM > /dev/null 2>&1; then
        echo "✓ Backup integrity verified"
    else
        echo "❌ Backup integrity check failed!"
        exit 1
    fi
    cd - > /dev/null
fi

# Read metadata
if [ -f "$BACKUP_DIR/backup-metadata.json" ]; then
    echo ""
    echo "📋 Backup Information:"
    cat "$BACKUP_DIR/backup-metadata.json" | grep -o '"[^"]*" *: *"[^"]*"' | sed 's/"//g'
    echo ""
fi

# Confirmation
echo "⚠️  WARNING: This will restore the cluster to the backup state"
echo "Press 'YES' to continue:"
read -r CONFIRM

if [ "$CONFIRM" != "YES" ]; then
    echo "❌ Restore cancelled"
    exit 1
fi

echo ""
echo "🔄 Starting restore process..."

# Create namespace if it doesn't exist
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
echo "✓ Namespace ready"

# Restore RBAC first (needed for other resources)
if [ -f "$BACKUP_DIR/rbac.yaml" ]; then
    echo "Restoring RBAC..."
    kubectl apply -f "$BACKUP_DIR/rbac.yaml" --namespace=$NAMESPACE
    echo "✓ RBAC restored"
fi

# Restore secrets
if [ -f "$BACKUP_DIR/secrets.yaml" ]; then
    echo "Restoring secrets..."
    kubectl apply -f "$BACKUP_DIR/secrets.yaml" --namespace=$NAMESPACE
    echo "✓ Secrets restored"
fi

# Restore configmaps
if [ -f "$BACKUP_DIR/configmaps.yaml" ]; then
    echo "Restoring configmaps..."
    kubectl apply -f "$BACKUP_DIR/configmaps.yaml" --namespace=$NAMESPACE
    echo "✓ Configmaps restored"
fi

# Restore PVCs
if [ -f "$BACKUP_DIR/pvcs.yaml" ]; then
    echo "Restoring PVCs..."
    kubectl apply -f "$BACKUP_DIR/pvcs.yaml" --namespace=$NAMESPACE
    echo "✓ PVCs restored"
fi

# Restore network policies
if [ -f "$BACKUP_DIR/network-policies.yaml" ]; then
    echo "Restoring network policies..."
    kubectl apply -f "$BACKUP_DIR/network-policies.yaml" --namespace=$NAMESPACE
    echo "✓ Network policies restored"
fi

# Restore all resources (deployments, services, etc)
if [ -f "$BACKUP_DIR/all-resources.yaml" ]; then
    echo "Restoring all resources..."
    kubectl apply -f "$BACKUP_DIR/all-resources.yaml" --namespace=$NAMESPACE
    echo "✓ All resources restored"
fi

# Wait for deployments
echo ""
echo "⏳ Waiting for deployments to be ready..."
kubectl rollout status deployment/frontend -n $NAMESPACE --timeout=300s || true
kubectl rollout status deployment/backend -n $NAMESPACE --timeout=300s || true
kubectl rollout status deployment/postgres -n $NAMESPACE --timeout=300s || true

echo ""
echo "📊 Restore Status:"
echo "=================="
kubectl get pods -n $NAMESPACE
echo ""
kubectl get svc -n $NAMESPACE

echo ""
echo "✅ Restore completed!"
echo "Verify your application is working correctly"