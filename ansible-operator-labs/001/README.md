# Pre-requisites

- Install [operator sdk](https://sdk.operatorframework.io/docs/installation/install-operator-sdk/)
- Install [ansible operator dependencies](https://sdk.operatorframework.io/docs/building-operators/ansible/installation/)
- Install [kustomize](https://kubernetes-sigs.github.io/kustomize/installation/)
- Install `make` - build uitlity

# Quickstart

## Quay Repository Setup

- Goto: http://quay.io
    - create an account if you don't already have one
- Create a repository
    - repository: `ansible-overeasy-operator`
    - make repository `public`
    - repository url: `quay.io/<username>/ansible-overeasy-operator`

## Login into Quay.io through docker

```bash
docker login -u <your-quay-username> quay.io
```

## Register the Operator CRD 

```bash
make install
```

## (Option 0) Run only the Playbook

```bash
ansible-playbook playbook.yml
```

## (Option 1) Run locally outside the cluster

```bash
make run
```

## (Option 2) Run as a Deployment inside the cluster

**Build and Push Image**

```bash
export IMG=quay.io/<username>/ansible-overeasy-operator:1.0.1

make docker-build docker-push
```

**Deploy the Operator**

To deploy to `ansible-operator-overeasy-system` namespace:

```bash
make deploy
```

At this point to see if your operator is installed:

```bash
kubectl -n ansible-operator-overeasy-system get all
```

you should have similar output: 

```code
NAME                                                                READY   STATUS      RESTARTS   AGE
pod/ansible-operator-overeasy-controller-manager-5dd865759c-fwfpg   2/2     Running     2          15h

NAME                                                                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/ansible-operator-overeasy-controller-manager-metrics-service   ClusterIP   10.43.185.51   <none>        8443/TCP   15h

NAME                                                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ansible-operator-overeasy-controller-manager   1/1     1            1           15h

NAME                                                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/ansible-operator-overeasy-controller-manager-5dd865759c   1         1         1       15h
```

## Create Operator CR Instance

```bash
kubectl create -f config/samples/ansible-operators-over-ez_v1alpha1_ansibleopsovereasy.yaml
```

## Validate Checklist

- [ ] - The operator will deploy an instance of the CR `ansibleopsovereasies.ansible-operators-over-ez.mydomain.com`
- [ ] - The CR will deploy a single busybox pod
- [ ] - The busybox pod will complete after a duration
- [ ] - After the busybox pod completes, the CR will have a `timeout` and `logged` flag set to `true`

## Undeploy the Operator

```bash
make undeploy
```