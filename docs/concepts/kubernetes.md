# Introduction to Kubernetes

This is a quick overview for those who are new to backend infrastructure. Kubernetes is a complicated topic, but we hope that this Kit will be a great starting point.

If you are more experienced, you can skip this and use the Kit to create infrastructure faster.

## Docker Containers

Docker is a tool that allows you to create containers. Containers are isolated environments that can run on any machine. You can think of them as virtual machines, but they are more lightweight.

These Docker containers are isolated from anything outside of the container (unless you set up networking between them). The point of these containers is to provide a consistent environment to run an application that you define.

## Kubernetes

Kubernetes is a tool that allows you to orchestrate these containers. It is a platform that allows you to deploy, scale, and manage your containers.

In practice, Kubernetes is a bunch of configuration files that describe the ideal state of the cluster. The power of Kubernetes is that when something goes wrong (doesn't match the configuration), it self-corrects.

For example, if a pod crashes, Kubernetes will automatically restart it. If a node goes down, Kubernetes will automatically move the pods to another node.

## Vocabulary

### Namespaces

A namespace is a way to group your resources. It is a logical separation of your resources.

### Pods

A pod is a group of containers that share the same network namespace. They are the smallest unit of deployment in Kubernetes.

### Nodes

A node is a machine that runs Kubernetes. It can be a physical machine or a virtual machine.

### Services

A service is a way to expose your pods to the outside world. It is a stable endpoint that routes traffic to the pods.

### Deployments

A deployment is a way to manage the lifecycle of your pods. It is a declarative way to describe the desired state of your pods.

### Ingress

An ingress is a way to expose your services to the outside world. It is a stable endpoint that routes traffic to the services.

### Helm

Helm is a package manager for Kubernetes. It is a way to manage the lifecycle of your charts.

### Kubectl

Kubectl is a command-line tool that allows you to interact with your Kubernetes cluster.
