# Automatic SSL Certificates

You have an app running in your Kubernetes cluster and need to secure it with SSL certificates. This guide helps you set up automatic SSL certificate management using Cert Manager with Let's Encrypt, so your app can be accessed securely over HTTPS without manual certificate management.

Keep in mind our setup already configures all this for you. Add a new app through the Hungrimind CLI, but this should help you understand the entire flow to understand when to use and not to use "staging" certificates.

## Background Knowledge

Cert Manager is a native Kubernetes certificate management controller that helps with issuing certificates from a variety of sources, like Let's Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, or self-signed certificates. These certificates are primarily used to secure your app with TLS and enable HTTPS. It ensures certificates stay valid and up to date by automatically renewing them before they expire.

The setup uses two `ClusterIssuer` resources: one for staging and one for production. This is a common practice to avoid hitting rate limits on the production Let's Encrypt servers while testing and developing.

## Prerequisites

Before starting, make sure you have followed [Guided tour cloud](../get-started/guided-tour-cloud.md) and [app a new app](add-an-app.md).

## Steps

### 1. Configure Ingress for SSL

When creating ingress resources for an app, add the cert-manager annotation to enable automatic certificate provisioning.

For simplicity, we have some of the dynamic values here, such as the domain name, but prefer having this in the `values.yaml` file. The same way it's done in [Add a New App](add-an-app.md).

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

### 2. Moving to production

As you can see in this, we have a domain set and the issuer set. The issuer, by default, will be a "staging" issuer. This is to avoid hitting rate limits for our SSL certificates when we are playing around. Once you are happy, change this to be `letsencrypt-prod` so Let's Encrypt can issue you a production certificate for SSL.

## Verification

After setting up your ClusterIssuers and configuring an ingress with SSL:

Check that your ClusterIssuers are ready:

```sh
kubectl get clusterissuers
```

You should see both issuers with "Ready" status as `True`.

Check that certificates are being issued:

```sh
kubectl get certificates -A
```

Visit your app URL with HTTPS to verify the certificate is working. For staging certificates, you'll see a browser warning (this is expected). For production certificates, you should see a valid, trusted certificate.

Check certificate details if needed:

```sh
kubectl describe certificate your-app-tls -n your-namespace
```

> [!NOTE]
> **staging vs production**
>
> The staging `ClusterIssuer` uses the Let's Encrypt staging server. Certificates issued by the staging server aren't trusted by browsers, but they're useful for verifying your certificate issuance process is working correctly. When you visit an app using a staging certificate, you'll likely see a browser warning about the page not being secure - this is expected, and you can typically proceed to the page anyway.
>
> Start with the staging issuer to test your configuration. Once you've verified everything works with the staging issuer, you can switch your ingress annotations from `cert-manager.io/issuer: "letsencrypt-staging"` to `cert-manager.io/issuer: "letsencrypt-prod"` to get a real, trusted certificate.
>
> The production issuer has strict rate limits, so avoid using it for testing to prevent hitting those limits.
