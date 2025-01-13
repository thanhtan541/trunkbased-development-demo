# Trunkbased-developement demo
------------
### Pre-requisites
You'll need to have:
- [Docker](https://www.docker.com/products/docker-desktop/): a tool to build docker images
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/): a CLI to interact with K8s cluster
- [Minikube](https://minikube.sigs.k8s.io/docs/): local k8s cluster
- [Kustomization](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/): a standalone tool to customize Kubernetes objects

### Installation
1. Clone this repo: [trunkbased-development-demo](https://github.com/thanhtan541/trunkbased-development-demo) .
2. Run validator scripts to verify all needed tools are installed in `./scripts/validator.sh`:
```bash
./scripts/validator.sh
```
3. There are Enviroment Variables need to be specifiedj.
  - **SLOT**: a number of pre-defined namespace to deploy your k8s resources
  - **RESOURCE_GROUP_PREFIX**: logical prefix of namespace
```bash
export RESOURCE_GROUP_PREFIX="front-end-dev" # this value is used for this demo
export SLOT=0

./do_something

# Remove when process is finished
unset RESOURCE_GROUP_PREFIX
unset SLOT
```

### Initialize pre-defined k8s namespace
- **Namespace** is used as a resource group for each development enviroments.
- It need to be created before running `./scripts/init_dev_env.sh`
- The reason (also the limitaton) of this approach is to have a controlable resources. Dynamically behavior would potentially flood the environment of this approach is to have a controlable resources. Dynamically behavior would potentially flood the environment.

```bash
kubectl create namespace ${RESOURCE_GROUP_PREFIX}-${SLOT}
```

### Initialize develoment enviroment
All the steps are included in `./scripts/init_dev_env.sh`

```bash
./scripts/init_dev_env.sh
```

### Remove local resources
```bash
./scripts/cleanup_dev_env.sh
```
