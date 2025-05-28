#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <your-instance-ip>"
  exit 1
fi

INSTANCE_IP=$1
KUBE_PORT="6443" # Default K3s port

echo "Creating cicd namespace..."
kubectl create namespace cicd

echo "Setting up Service Account for GitHub Actions in cicd namespace..."
kubectl create serviceaccount github-actions --namespace cicd

echo "Creating admin rolebinding for GitHub Actions Service Account..."
kubectl create clusterrolebinding github-actions-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=cicd:github-actions

echo "Creating long-lived token for GitHub Actions Service Account..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: github-actions-secret
  namespace: cicd
  annotations:
    kubernetes.io/service-account.name: github-actions
type: kubernetes.io/service-account-token
EOF

echo "---------------------------------------------------------------------"
echo "GitHub Actions Secrets to configure:"
echo "---------------------------------------------------------------------"

echo "KUBE_HOST: ${INSTANCE_IP}:${KUBE_PORT}"
echo ""

echo "KUBE_CERTIFICATE:"
kubectl get secret github-actions-secret -n cicd -o jsonpath='{.data.ca\.crt}'
echo ""

echo "KUBE_TOKEN:"
kubectl get secret github-actions-secret -n cicd -o jsonpath='{.data.token}' | base64 --decode; echo
echo "---------------------------------------------------------------------"
echo "Make sure to add these as secrets in your GitHub repository settings."
echo "---------------------------------------------------------------------" 