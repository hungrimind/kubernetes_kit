# Kubernetes Kit

> **Hungrimind has shut down.** This kit is now free and open to everyone. It is
> no longer actively maintained, but you are welcome to use it, fork it, and build on it.

## Overview

The Kubernetes Kit is designed for developers and teams who want to own their infrastructure and are looking for low-cost, yet highly scalable, Kubernetes solutions. This kit empowers you to build and manage your deployments with full control and transparency, providing a solid foundation that balances cost-effectiveness with the ability to grow.

## What's Included

*   **🚀 Pre-configured Manifests:** A comprehensive set of YAML templates for common Kubernetes resources (Deployments, Services, Ingress, ConfigMaps, Secrets, etc.) to speed up your development.
*   **💻 CLI:** Our [command line tool](https://github.com/hungrimind/hungrimind-cli) that creates your infrastructure folder, fills in the required values, and adds new apps.

## Getting Started

You need Node.js 18+ for the CLI, and a server you can SSH into for the cluster.

### With the CLI (recommended)

```bash
npm install -g github:hungrimind/hungrimind-cli
hungrimind kubernetes create my_infrastructure
```

The CLI downloads this kit into `my_infrastructure/`, asks you for every required
`{{placeholder}}` value in the `values` files (each one has a comment explaining
what it is for), and then offers to run `first_install.sh`, which installs the
preconfigured apps on your cluster.

Other commands, run from inside your infrastructure folder:

| Command | What it does |
| --- | --- |
| `hungrimind kubernetes configure` | Fill in any placeholders you skipped |
| `hungrimind kubernetes install` | Run `first_install.sh` (checks required values first) |
| `hungrimind kubernetes add app` | Create a Helm chart and GitHub Actions workflow for a new app |

### Without the CLI

1. Clone or download this repo.
2. Search the repo for `{{` and replace every placeholder (for example
   `{{metal-lb-server-ip}}`, `{{cert-staging-email}}`, `{{cert-prod-email}}`)
   with your own value. Each one has a comment explaining what it is for.
3. On your server, run `./first_install.sh`.

To add an app without the CLI, copy the templates from
[`templates/kubernetes/app`](https://github.com/hungrimind/hungrimind-cli/tree/main/templates/kubernetes/app)
in the CLI repo and replace their placeholders by hand.

## Guiding Principles

### Minimal YAML & Sensible Defaults

Every piece of configuration adds complexity. We believe in providing essential building blocks and sensible defaults, not depending on overly complex Helm charts or custom operators (as much as it makes sense). We primarily use standard Kubernetes resources; the rest is well-documented and straightforward.

### Kubernetes Best Practices

There are many ways to configure Kubernetes. They can all work, but the more time you spend choosing and deliberating, the less time you spend building products. We incorporate battle-tested Kubernetes best practices for security, scalability, observability, and resilience.

### Own Your Configuration

This could have been a package or a complex operator, but we believe in owning your configuration. All these features are code that you can see, explore, and update for your use cases. (Let us know about your updates so we can potentially improve the kit.)

### Align with CNCF Standards

Our goal is to align closely with the Cloud Native Computing Foundation (CNCF) recommendations and best practices. When something is missing or can be improved, we use our expertise to fill the gaps while adhering to community standards.