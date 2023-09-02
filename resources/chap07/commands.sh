kubectl create deployment alpaca-prod --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=3 --port=8080 
kubectl label deployment alpaca-prod ver=1 app=alpaca env=prod --overwrite
kubectl expose deployment alpaca-prod


kubectl create deployment bandicoot-prod --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=2 --port=8080
kubectl label deployment bandicoot-prod ver=2 app=bandicoot env=prod --overwrite
kubectl expose deployment bandicoot-prod


kubectl get services -o wide


ALPACA_POD=$(kubectl get pods -l app=alpaca-prod -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $ALPACA_POD 48858:8080


ssh voldemort2 -L 8080:localhost:30694