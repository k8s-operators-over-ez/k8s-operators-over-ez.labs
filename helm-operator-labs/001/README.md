# Pre-requisites

- Install [operator sdk](https://sdk.operatorframework.io/docs/installation/install-operator-sdk/)
- Install [helm 3](https://helm.sh/docs/intro/install/)
- Install [kustomize](https://kubernetes-sigs.github.io/kustomize/installation/)
- Install `make` - build uitlity

# Quickstart

## Setup Notes

For this example, customizations were added to the `Makefile` specifically to the following Make targets: 

```Makefile
# Deploy controller in the configured Kubernetes cluster in ~/.kube/config
deploy: kustomize
	cd config/manager && $(KUSTOMIZE) edit set image controller=${IMG}
	$(KUSTOMIZE) build config/default | kubectl apply -f -
	kubectl apply -f rbac/rbac.yaml 
	cp scripts/* /home/hershey/tmp/vol

# Undeploy controller in the configured Kubernetes cluster in ~/.kube/config
undeploy: kustomize
	$(KUSTOMIZE) build config/default | kubectl delete -f -
	kubectl delete -f rbac/rbac.yaml 
	rm -rf /home/hershey/tmp/vol/*
```

For RBAC, a Service Account, Role, and Rolebinding were added to allow for the execution the `kubectl` w/in a container to communicate with a local cluster. 

For Persistent Volumes, scripts were copied over to map a local path to a persistent volume path. 

To be precisely clear about this, a local K3D cluster was created with these volume mappings. 

For example: 

```bash
k3d cluster create demo --api-port 6550 --servers 1 --agents 3 --port 8090:80@loadbalancer --volume /home/hershey/tmp/vol:/tmp/vol --wait
```

You'll need to make sure that the following path: `/home/hershey/tmp/vol` exists in your environment. 

## Quay Repository Setup

- Goto: http://quay.io
    - create an account if you don't already have one
- Create a repository
    - repository: `helm-overeasy-operator`
    - make repository `public`
    - repository url: `quay.io/<username>/helm-overeasy-operator`

## Login into Quay.io through docker

```bash
 docker login -u <your-quay-username> quay.io
```

## Register the Operator CRD 

```bash
make install
```

## Run as a Deployment inside the cluster

**Build and Push Image**

```bash
export IMG=quay.io/<username>/helm-overeasy-operator:1.0.1

make docker-build docker-push
```

**Deploy the Operator**

To deploy to `helm-operator-labs-system` namespace:

```bash
make deploy
```

At this point to see if your operator is installed:

```bash
kubectl -n helm-operator-labs-system get all
```

you should have similar output: 

```code
NAME                                                        READY   STATUS    RESTARTS   AGE
pod/helm-operator-labs-controller-manager-d69786c5d-5nk29   2/2     Running   0          5h11m

NAME                                                            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/helm-operator-labs-controller-manager-metrics-service   ClusterIP   10.43.139.116   <none>        8443/TCP   5h11m

NAME                                                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/helm-operator-labs-controller-manager   1/1     1            1           5h11m

NAME                                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/helm-operator-labs-controller-manager-d69786c5d   1         1         1       5h11m
```

## Create Operator CR Instance

```bash
kubectl create -f config/samples/example_v1alpha1_helmopsovereasy.yaml
```

## Validate Checklist

- [ ] - The operator will deploy an instance of the CR `helmopsovereasies.example.com`
- [ ] - The CR will deploy a single busybox pod
- [ ] - The busybox pod will complete after a duration
- [ ] - After the busybox pod completes, the CR will have a `timeout` and `logged` flag set to `true`

## Undeploy the Operator

```bash
make undeploy
```