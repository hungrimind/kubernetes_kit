# CLI Reference

The [Hungrimind CLI](https://github.com/hungrimind/hungrimind-cli) creates your
infrastructure folder from this kit. It downloads the kit straight from GitHub,
so no account or login is needed.

### Install and requirements

Requires Node.js 18 or newer.

Install globally from GitHub:

```sh
npm install -g github:hungrimind/hungrimind-cli
```

Verify the install:

```sh
hungrimind --version
```

### Basic usage

Get help:

```sh
hungrimind --help
hungrimind kubernetes --help
```

### Kubernetes

Create a new Kubernetes project and fill the required placeholders. This will also ask you to run the install script:

```sh
hungrimind kubernetes create NAME
```

### Configure

When you create a project, you will be asked questions to fill in placeholders; these will only cover the required placeholders. To be asked about all placeholders you can run:

```sh
hungrimind kubernetes configure
```

### Install

Run `first_install.sh` (it checks that the required placeholders are filled first):

```sh
hungrimind kubernetes install
```

### Add an app

Create a Helm chart and GitHub Actions workflow for a new app. See [Add a New App](../guides/add-an-app.md).

```sh
hungrimind kubernetes add app
```

See the [Kubernetes Kit Guided Tour](../get-started/guided-tour-local.md) for a walkthrough.
