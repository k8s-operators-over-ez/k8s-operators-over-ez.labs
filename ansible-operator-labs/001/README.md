# Pre-requisites

- Install [operator sdk](https://sdk.operatorframework.io/docs/installation/install-operator-sdk/)

- Install [ansible operator dependencies](https://sdk.operatorframework.io/docs/building-operators/ansible/installation/)

- make - build uitlity

# Quickstart

## Quay Repository Setup

- Goto: http://quay.io
    - create an account if you don't already have one
- Create a repository
    - repository: `ansible-overeasy-operator`
    - make repository `public`
    - repository url: `quay.io/username/ansible-overeasy-operator`

## Deploy Operator

```bash
make docker-build docker-push IMG=quay.io/kelee/ansible-overeasy-operator:1.0.1

 export IMG=quay.io/<username>/ansible-overeasy-operator:1.0.1

 make install

 make deploy
```

At this point to see if your operator is installed switch your kubernetes namespace to: `ansible-operator-overeasy-system`

```bash
oc project ansible-operator-overeasy-system
oc get all
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
oc create -f config/samples/ansible-operators-over-ez_v1alpha1_ansibleopsovereasy.yaml
```

## Validate Checklist

- [ ] - The operator will deploy an instance of the CR `ansibleopsovereasies.ansible-operators-over-ez.mydomain.com`
- [ ] - The CR will deploy a single busybox pod
- [ ] - The busybox pod will complete after a duration
- [ ] - After the busybox pod completes, the CR will have a `timeout` and `logged` flag set to `true`

