# wls-k8s-mg
My examples of using Oracle WebLogic in a Kubernetes environment

# Startup Kubernetes
Startup the Kubernetes environment and open the dashbaord in a browser.

```bash
minikube start
minikube dashboard
```
# Environment Setup
Establish environment settings that are shared across steps.

```bash
eval $(minikube docker-env)
docker login
 
export PVHOME=~/Downloads/weblogic-k8s-pv/
```
# Persistent Volume

Create the persistent volume and a claim against that volume

```bash
# Create the folder, the persistent volume, and a claim against it
mkdir -p $PVHOME
chmod -R 777 $PVHOME

kubectl create -f k8s/persistent-volume.yaml
kubectl create -f k8s/persistent-volume-claim.yaml
 
# Check the status
kubectl get pv
NAME      CAPACITY   ACCESSMODES   RECLAIMPOLICY   STATUS    CLAIM                 STORAGECLASS   REASON    AGE
pv001     5Gi        RWX           Recycle         Bound     default/pv001-claim   weblogic                 11s
 
kubectl get pvc
NAME          STATUS    VOLUME    CAPACITY   ACCESSMODES   STORAGECLASS   AGE
pv001-claim   Bound     pv001     5Gi        RWX           weblogic       6s
```

# Populate the Persistent Volume
Initialize the persistent volume with the scripts and applications that will be required.

```bash
# Create the folders
mkdir -p $PVHOME/scripts
 
# Populate the scripts folder
cp scripts/create-domain.py $PVHOME/scripts
cp scripts/create-domain-job.sh $PVHOME/scripts
```

# Create Domain
Create a domain on the persistent volume that will be used by WebLogic.

```bash
kubectl create -f k8s/create-domain-job.yaml
```


# Cleanup

```bash
kubectl delete -f k8s/create-domain-job.yaml
kubectl delete -f k8s/persistent-volume-claim.yaml
kubectl delete -f k8s/persistent-volume.yaml
 
rm -rf $PVHOME
```