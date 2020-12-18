TIMEOUT=$(kubectl get helmopsovereasies.example.com helmopsovereasy-sample -o jsonpath='{.spec.timeout}')
MESSAGE=$(kubectl get helmopsovereasies.example.com helmopsovereasy-sample -o jsonpath='{.spec.message}')

if  ([ -z "$TIME" ] || [ -z "$MESSAGE" ])
then
    RESPONSE=$(curl -sb -H "Accept: application/json" "http://my-json-server.typicode.com/keunlee/test-rest-repo/golang-lab00-response")
    TIMEOUT=$(echo $RESPONSE | jq -r '.timeout')
    MESSAGE=$(echo $RESPONSE | jq -r '.message') 
fi

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  annotations:
    meta.helm.sh/release-name: helmopsovereasy-sample
    meta.helm.sh/release-namespace: workspace-002
  creationTimestamp: null
  labels:
    app.kubernetes.io/managed-by: Helm
    run: busybox
  name: busybox
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - sleep "${TIMEOUT}"; echo "${MESSAGE}"
    image: busybox
    name: busybox
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
EOF

sleep $((TIMEOUT+2))

kubectl patch helmopsovereasies.example.com helmopsovereasy-sample --type=merge --patch '{"spec":{"subresources":{"status":{"expired":true,"logged":true}}}}'