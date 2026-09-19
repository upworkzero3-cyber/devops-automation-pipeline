#!/bin/bash

# Disaster Recovery - Backup Script
# This script backs up the entire Kubernetes cluster state

set -e

NAMESPACE="devops-pipeline"
BACKUP_DIR="backups/$(date +%Y-%m-%d-%H-%M-%S)"
BACKUP_NAME="cluster-backup-$(date +%Y-%m-%d-%H-%M-%S)"

echo "🔄 Starting Kubernetes Cluster Backup..."
echo "Namespace: $NAMESPACE"
echo "Backup Directory: $BACKUP_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "📦 Backing up cluster resources..."

# Backup all resources
kubectl get all -n $NAMESPACE -o yaml > "$BACKUP_DIR/all-resources.yaml"
echo "✓ Backed up all resources"

# Backup secrets
kubectl get secrets -n $NAMESPACE -o yaml > "$BACKUP_DIR/secrets.yaml"
echo "✓ Backed up secrets"

# Backup configmaps
kubectl get configmaps -n $NAMESPACE -o yaml > "$BACKUP_DIR/configmaps.yaml"
echo "✓ Backed up configmaps"

# Backup PVCs
kubectl get pvc -n $NAMESPACE -o yaml > "$BACKUP_DIR/pvcs.yaml"
echo "✓ Backed up PVCs"

# Backup PVs
kubectl get pv -o yaml > "$BACKUP_DIR/pvs.yaml"
echo "✓ Backed up PVs"

# Backup RBAC
kubectl get roles,rolebindings -n $NAMESPACE -o yaml > "$BACKUP_DIR/rbac.yaml"
echo "✓ Backed up RBAC"

# Backup network policies
kubectl get networkpolicies -n $NAMESPACE -o yaml > "$BACKUP_DIR/network-policies.yaml" 2>/dev/null || echo "✓ No network policies found"

# Backup ingress
kubectl get ingress -n $NAMESPACE -o yaml > "$BACKUP_DIR/ingress.yaml" 2>/dev/null || echo "✓ No ingress found"

# Backup services
kubectl get services -n $NAMESPACE -o yaml > "$BACKUP_DIR/services.yaml"
echo "✓ Backed up services"

# Create metadata file
cat > "$BACKUP_DIR/backup-metadata.json" <<EOF
{
  "backup_name": "$BACKUP_NAME",
  "timestamp": "$(date -Iseconds)",
  "namespace": "$NAMESPACE",
  "kubernetes_version": "$(kubectl version --short 2>/dev/null | grep Server || echo 'unknown')",
  "cluster_name": "$(kubectl config current-context)",
  "node_count": "$(kubectl get nodes --no-headers | wc -l)",
  "pod_count": "$(kubectl get pods -n $NAMESPACE --no-headers | wc -l)"
}
EOF
echo "✓ Created backup metadata"

# Create verification report
echo ""
echo "📋 Backup Verification:"
echo "========================"
echo "Total backup size: $(du -sh $BACKUP_DIR | cut -f1)"
echo "Files backed up:"
ls -lh "$BACKUP_DIR" | awk 'NR>1 {print "  - " $9 " (" $5 ")"}'
echo ""

# Create checksum for integrity verification
sha256sum "$BACKUP_DIR"/* > "$BACKUP_DIR/CHECKSUM"
echo "✓ Created checksums for integrity verification"

echo ""
echo "✅ Backup completed successfully!"
echo "Backup location: $BACKUP_DIR"
echo ""
echo "To restore: bash scripts/recovery/restore.sh $BACKUP_DIR"