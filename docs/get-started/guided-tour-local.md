# Guided Tour Local

This guided tour is a walkthrough of setting up Kubernetes Kit locally. It doesn’t cover everything, but after walking through it, you should have a sense of how to work with it.

Development with Kubernetes is different than traditional development. The thing we are "developing" is not an application, but backend infrastructure.

To do this, we need to create a Kubernetes cluster on our local machine and then deploy an app to it. This can be done using **minikube**.

Minikube is a tool that creates a Docker container with a Kubernetes cluster running in it. It's a bit funny because you're running a Docker container with a Kubernetes cluster, where the purpose is to orchestrate Docker containers.

But it's a good way to get started with Kubernetes, and a good way to test the kit before deploying to a real cluster.

## Prerequisites

1. Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/)
2. Install minikube using `brew install minikube` if you are on Mac (or use the [minikube website](https://minikube.sigs.k8s.io/docs/start/))

> Minikube should install kubectl (you can check by running `kubectl version`). If it doesn't, install kubectl using `brew install kubectl` if you are on Mac (or use the [kubectl website](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/))

3. Install Helm using `brew install helm` if you are on Mac (or use the [Helm website](https://helm.sh/docs/intro/install/))
4. Run `minikube start --driver=docker`
5. You can see minikube running in Docker Desktop or by running the `minikube status` command in your terminal.

At this point, we have a Kubernetes cluster running locally; now we can add our preconfigured app to it.

## Deploying Kubernetes Kit to Minikube

Install the Hungrimind CLI globally from GitHub (no account needed). It is used to pull down the latest version of Kubernetes Kit.

```bash
npm install -g github:hungrimind/hungrimind-cli
```

### Create a New Kubernetes setup

First run `minikube ip`, you will need this IP in the setup.

Generate your Kubernetes setup that uses the boilerplate with the CLI:

```bash
hungrimind kubernetes create my_infrastructure
```

Replace `my_infrastructure` with your desired project name.

### Answer the prompts

Kubernetes works with configuration files. These need to have the correct values for it to work. Within the Kubernetes Kit, each value contains a comment about how it's used.

Once this is done, you will have successfully cloned the project to your local machine. The next step is to deploy the preconfigured apps to the cluster, which is done by running the `first_install.sh` script. You can do this within the setup flow or do it later.

> ✅ You should now have a cluster running!
> Run `kubectl get pods --all-namespaces` to see the running app.

## Deploy an App

Because this is running a local setup, we are not going to cover external port forwarding and similar technical aspects.

But we will still [deploy an app](../guides/add-an-app.md) on localhost, which we can interact with using kubectl port-forwarding.

First, navigate into your infrastructure folder, then run the following command to create an app:

```sh
hungrimind kubernetes add app
```

Since this minikube is for local development, we won't be using domain names in this guided tour. So you can set these values to anything (it won't be used). But if you plan on deploying this infrastructure, use the deployed domain names.

> You can use `machine-info` for app name and `hungrimind` as the Docker username; this is a public image you can test with.

```sh
hungrimind kubernetes add app
? App name: machine-info
? App description: machine info
? Production domain (e.g., playing.hungrimind.com): playing.hungrimind.com
? Development domain (e.g., playing-dev.hungrimind.com): playing-dev.hungrimind.com
? Docker username: hungrimind
```

Now you should be able to see a folder based on the name you provided. The next step is to deploy it to our cluster:

```sh
cd machine-info
helm upgrade --install machine-info . --namespace machine-info --create-namespace --values ./values.yaml --debug --wait
```

Now you should see your app running when you do:

```sh
kubectl get pods -n machine-info
```

Use that name now to port forward to localhost:

```sh
kubectl port-forward svc/machine-info 8080:80 -n machine-info
```

Now you should be able to access it through your IP, such as [http://localhost:8080/version](http://localhost:8080/version)

## Next Steps

Now that you have an understanding of running Kubernetes (k3s) locally and have deployed a test app, you should be ready to do the real thing with a server, which you can follow the [Guided Tour using Hetzner](guided-tour-cloud.md).
