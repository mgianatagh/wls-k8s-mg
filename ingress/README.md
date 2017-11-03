# Ingress Example

## Startup the Environment
```bash
cd ingress
minikube start
minikube dashboard
eval $(minikube docker-env --shell=bash)
```
## Deploy WebLogic as a Service
```bash
# Deploy the weblogic image, then look at the log file
# to find the generated ammin password
kubectl create -f wls-admin-service.yml
```
## Traefik Load Balancer
```bash
# Setup Role Based Access Control configuration
kubectl create -f traefik-rbac.yml

# Deploy Traefik
kubectl create -f traefik-deployment.yml
 
# Deploy the Traefik Web UI
kubectl create -f traefik-web-ui.yml
 
# Get the Cluster IP of the traefik-web-ui service (for example, http://192.168.99.100:30080)
kubectl get services -n kube-system
 
# Launch the Traefik Web UI
minikube service -n kube-system traefik-web-ui 
 
# Create the ingress to loadbalance between the two admin servers
kubectl create -f ingress.yml
 
# Get coordinates of service
kubectl get svc -n kube-system
 
# Example URL for logging into WebLogic console
# http://192.168.99.100:30129/console/
```

## Cleanup
```bash
kubectl delete -f ingress.yml
kubectl delete -f traefik-web-ui.yml
kubectl delete -f traefik-deployment.yml
kubectl delete -f traefik-rbac.yml
kubectl delete -f wls-admin-service.yml
 
minikube stop
```