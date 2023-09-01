kubectl create deployment alpaca-prod --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=2
kubectl label deployment alpaca-prod ver=1 app=alpaca env=prod --overwrite


kubectl create deployment alpaca-test --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=1
kubectl label deployment alpaca-test ver=2 app=alpaca env=test --overwrite


kubectl create deployment bandicoot-prod --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=2
kubectl label deployment bandicoot-prod ver=2 app=bandicoot env=prod --overwrite


kubectl create deployment bandicoot-staging --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=1
kubectl label deployment bandicoot-staging ver=2 app=bandicoot env=staging --overwrite


kubectl get deployments --show-labels


kubectl label deployments alpaca-test "canary=true"


kubectl get deployments -L canary


kubectl label deployments alpaca-test "canary-"


kubectl get pods --show-labels


kubectl get deployments --selector="ver=2"


kubectl get deployments --selector="app=bandicoot,ver=2"


kubectl get deployments --selector="app in (alpaca,bandicoot)"


kubectl get deployments --selector="canary"


kubectl get deployments --selector='!canary'


kubectl get deployments -l 'ver=2,!canary'