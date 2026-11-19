# Configure ingress with nginx

Nginx Ingress is a widely used solution to manage external access to HTTP/S services running in a Kubernetes cluster. While Kubernetes Services (like NodePort or LoadBalancer) provide ways to expose services, an Ingress controller like Nginx Ingress offers a more flexible/feature-rich way to handle incoming traffic.

Let's take a look at how it works and some of the configurations we have.

## Core Concepts

### How Nginx Ingress Works

Nginx Ingress operates by deploying an Nginx web server instance within your Kubernetes cluster. This Nginx instance acts as a reverse proxy and load balancer, directing external HTTP/S traffic to your internal Kubernetes services based on rules you define.

Traffic routing is defined using Kubernetes `Ingress` objects. These objects specify rules, such as which hostnames (e.g., `myapp.example.com`) or paths (e.g., `/api`) should be directed to which backend Kubernetes app (machine-info.example.com -> machine-info app).

The Nginx Ingress controller, a pod (or set of pods) in your cluster, constantly watches for these `Ingress` resources. Upon detecting a new or updated Ingress resource, it dynamically reconfigures the underlying Nginx server to implement these routing rules.

The Nginx server itself is exposed externally, typically via a Service of type `LoadBalancer` (on cloud providers or with MetalLB for bare metal) or `NodePort`. When external traffic hits this Nginx instance, Nginx inspects the request (e.g., hostname, path) and uses the configured rules to proxy the request to the appropriate internal app and its backend Pods.

### Why

This architecture offers several benefits: it enables hostname and path-based routing, allowing you to direct traffic for different hostnames or URL paths to different services. SSL/TLS termination can be handled at the Ingress layer, simplifying your application services. Nginx also automatically load balances traffic across the pods of your backend services.

You can leverage Nginx for advanced configurations like URL rewrites, request/response header manipulation, rate limiting, and IP whitelisting through annotations on your Ingress resources.

## How to expose an app

### 1: Exposing your app

To expose an app, you need to have an ingress. Below is an example ingress using the staging environment for SSL certificates.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: your-app
  annotations:
    cert-manager.io/issuer: "letsencrypt-staging" # Start with staging
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - your-app.yourdomain.com
      secretName: your-app-tls
  rules:
    - host: your-app.yourdomain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: your-app
                port:
                  number: 80
```

This configuration routes traffic for the specified host and path `/` to `your-app` on port `3000`, while the `cert-manager.io/cluster-issuer` annotation tells `cert-manager` to automatically procure a TLS certificate from Let's Encrypt.

## Verification

Once you have deployed it, you should be able to verify it by running the following command and accessing the domain if you have the domain set up.

```sh
kubectl get ingress your-app -o wide
```

### High Availability

The Nginx Ingress controller is typically deployed as a Kubernetes Deployment, ensuring a specified number of replicas (instances) are always running. If one Ingress controller pod crashes, Kubernetes automatically starts a new one.

The Nginx service that exposes the controller externally (usually of type `LoadBalancer`) also ensures that traffic is directed to a healthy Ingress controller pod, providing high availability for your ingress point.
