# Pre-requisites

- Install [operator sdk](https://sdk.operatorframework.io/docs/installation/install-operator-sdk/)
- Install [kustomize](https://kubernetes-sigs.github.io/kustomize/installation/)
- Install [golang](https://golang.org/doc/install)
- Install `make` - build uitlity

# Quickstart

## Quay Repository Setup

- Goto: http://quay.io
    - create an account if you don't already have one
- Create a repository
    - repository: `golang-overeasy-operator`
    - make repository `public`
    - repository url: `quay.io/<username>/golang-overeasy-operator`

## Register the Operator CRD 

```bash
make install
```

## (Option 1) Run locally outside the cluster

```bash
make run ENABLE_WEBHOOKS=false
```

## (Option 2) Run as a Deployment inside the cluster

**Build and Push Image**

```bash
export USERNAME=<quay-username>
export IMG=quay.io/<username>/golang-overeasy-operator:v1.0.1

make docker-build 
make docker-push
```

**Deploy the Operator**

To deploy to `golang-operator-overeasy-system` namespace: 

```bash
cd config/default/ && kustomize edit set namespace "golang-operator-overeasy-system" && cd ../..

make deploy
```
At this point to see if your operator is installed switch your kubernetes namespace to: `golang-operator-overeasy-system`

```bash
oc project golang-operator-overeasy-system
oc get all
```

you should have similar output: 

```code
NAME                                                                READY   STATUS      RESTARTS   AGE
pod/golang-operator-overeasy-controller-manager-5dd865759c-fwfpg   2/2     Running     2          15h

NAME                                                                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/golang-operator-overeasy-controller-manager-metrics-service   ClusterIP   10.43.185.51   <none>        8443/TCP   15h

NAME                                                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/golang-operator-overeasy-controller-manager   1/1     1            1           15h

NAME                                                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/golang-operator-overeasy-controller-manager-5dd865759c   1         1         1       15h

```

## Create Operator CR Instance

```bash
oc create -f config/samples/operators-over-ez_v1alpha1_opsovereasy.yaml
```

## Validate Checklist

- [ ] - The operator will deploy an instance of the CR `golangopsovereasies.ansible-operators-over-ez.mydomain.com`
- [ ] - The CR will deploy a single busybox pod
- [ ] - The busybox pod will complete after a duration
- [ ] - After the busybox pod completes, the CR will have a `timeout` and `logged` flag set to `true`

