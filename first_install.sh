#!/bin/bash

echo "Kubernetes Kit Setup"
echo "===================="
echo ""
echo "Please choose your Kubernetes environment:"
echo ""
echo "1) Minikube - Local development environment"
echo "   - Runs on your local machine"
echo "   - Perfect for development and testing"
echo "   - Uses Docker"
echo ""
echo "2) K3s (LINUX) - Production deployment"
echo "   - Lightweight Kubernetes for production"
echo "   - Ideal for root servers (Hetzner, DigitalOcean, etc.)"
echo "   - Real production workloads"
echo ""

while true; do
    read -p "Enter your choice (1 for Minikube, 2 for K3s): " choice
    case $choice in
        1)
            ENVIRONMENT="minikube"
            echo "You selected Minikube for local development."
            break
            ;;
        2)
            ENVIRONMENT="k3s"
            echo "You selected K3s for production deployment."
            break
            ;;
        *)
            echo "Please enter 1 or 2."
            ;;
    esac
done

echo ""
echo "Starting installation for $ENVIRONMENT..."
echo ""

if [ "$ENVIRONMENT" = "k3s" ]; then
	echo "Installing Helm (using official Buildkite repository)..."

	# Download and install the current GPG signing key
	# Note: The 'curl' package must be installed for this to work.
	curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

	# Add the new Helm repository line
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

	# Update package lists and install Helm
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl gnupg helm

    echo "Installing k3s..."
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=servicelb,traefik" sh -s -

    echo "Setting KUBECONFIG environment variable for the current session..."
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
else
    echo "Verifying Minikube setup..."
    echo ""
    
    # Check if required tools are installed
    MISSING_TOOLS=()
    
    if ! command -v minikube &> /dev/null; then
        MISSING_TOOLS+=("minikube")
    fi
    
    if ! command -v kubectl &> /dev/null; then
        MISSING_TOOLS+=("kubectl")
    fi
    
    if ! command -v helm &> /dev/null; then
        MISSING_TOOLS+=("helm")
    fi
    
    if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
        echo "✅ All required tools are installed!"
        echo "✅ Minikube: $(minikube version --short)"
        echo "✅ Kubectl: $(kubectl version --client --short 2>/dev/null || echo "Available")"
        echo "✅ Helm: $(helm version --short)"
        echo ""
    else
        echo "❌ Missing required tools: ${MISSING_TOOLS[*]}"
        echo ""
        echo "Please install minikube, kubectl, and helm before running this script."
        echo "Exiting..."
        exit 1
    fi
fi

echo "Installing Metallb..."
helm repo add metallb https://metallb.github.io/metallb
helm repo update
helm upgrade --install metallb metallb/metallb \
	--version v0.14.9 \
	--namespace metallb-system \
	--create-namespace \
    --debug \
    --wait

echo "Waiting for MetalLB controller to be ready..."
kubectl rollout status deployment/metallb-controller -n metallb-system --timeout=300s
echo "Waiting for MetalLB speaker to be ready..."
kubectl rollout status daemonset/metallb-speaker -n metallb-system --timeout=300s

echo "Installing Metallb Config..."
helm upgrade --install metallb-config ./metallb-config \
	--namespace metallb-system \
	--values ./metallb-config/values.yaml \
    --debug \
	--wait \

echo "Installing Ingress Nginx..."
helm upgrade --install ingress-nginx ingress-nginx \
	--repo https://kubernetes.github.io/ingress-nginx \
	--version 4.11.3 \
	--namespace ingress-nginx \
	--create-namespace \
	--values ./nginx-config/values.yaml \
    --debug \
	--wait

echo "Installing Cert Manager..."
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
	--version v1.16.2 \
  --namespace cert-manager \
  --create-namespace \
  --values ./cert-manager-config/values.yaml \
  --debug \
  --wait

echo "Installing Cert Manager Custom Config..."
helm upgrade --install cert-manager-custom-config ./cert-manager-custom-config \
	--namespace cert-manager \
	--values ./cert-manager-custom-config/values.yaml \
	--wait \
    --debug
