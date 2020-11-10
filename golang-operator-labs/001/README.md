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
    - repository: `overeasy-operator`
    - make repository `public`
    - repository url: `quay.io/<username>/overeasy-operator`

## Login into Quay.io through docker

```bash
 docker login -u <your-quay-username> quay.io
```

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
export IMG=quay.io/<username>/overeasy-operator:1.0.1

make docker-build docker-push
```

**Deploy the Operator**

To deploy to `operator-overeasy-system` namespace: 

```bash
make deploy
```
At this point to see if your operator is installed switch your kubernetes namespace to: `operator-overeasy-system`

```bash
oc project operator-overeasy-system
oc get all
```

you should have similar output: 

```code
NAME                                                                READY   STATUS      RESTARTS   AGE
pod/operator-overeasy-controller-manager-5dd865759c-fwfpg   2/2     Running     2          15h

NAME                                                                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/operator-overeasy-controller-manager-metrics-service   ClusterIP   10.43.185.51   <none>        8443/TCP   15h

NAME                                                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/operator-overeasy-controller-manager   1/1     1            1           15h

NAME                                                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/operator-overeasy-controller-manager-5dd865759c   1         1         1       15h

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


## Undeploy the Operator

```bash
make undeploy
```