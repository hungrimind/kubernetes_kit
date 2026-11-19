# MetalLB Load Balancing

MetalLB is a load balancer solution specifically designed for Kubernetes clusters that are not running on cloud providers (often called "bare metal" clusters). In typical cloud environments, Kubernetes can automatically request and use a cloud provider's load balancer when you create a Service of type `LoadBalancer`. MetalLB brings this same convenience to your own hardware.

## Core Concepts

### The Bare Metal Challenge

When you're running Kubernetes on your own servers, there isn't a native way to assign an external IP address to your app that is reachable from outside the cluster network. MetalLB solves this by taking on the role of an external load balancer.

## Steps

### 1. Configuring IP

You need the IP of your server. If you are using Hetzner for your dedicated server, you should find that IP in your dashboard or through the `ipconfig` terminal command.

Then you replace the address with your server IP.

```yaml
# metallb-config/values.yaml
addresspool:
  addresses:
    {{metal-lb-server-ip}}/32 # IP address of your server
```

> [!NOTE]
> **CLI**
>
> You can also use `hungrimind kubernetes configure` and it will walk through all the placeholders we provide, and you can skip the ones not relevant to you.

### Verification

If you curl your IP, you should now get an nginx response.

```sh
curl http://{{metal-lb-server-id}}
```

You can also verify that it's in the cluster with

```sh
kubectl get pods -n metallb-system
```
