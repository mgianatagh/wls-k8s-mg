# wls-k8s-mg
My examples of using Oracle WebLogic in a Kubernetes environment

# Startup Kubernetes
Startup the Kubernetes environment and open the dashboard in a browser.

```bash
minikube start
minikube dashboard
```

# Pull the Docker image
This step is only required after the initial creation of the local kubernetes cluster running in VirtualBox
```bash
eval $(minikube docker-env --shell=bash --no-proxy)
docker login
docker pull store/oracle/weblogic:12.2.1.2
```

# Create the Persistent Volume
Create the base folder of the persistent volume.  This step is only required once.

```bash
sudo -s
cd /
mkdir -m 777 wls-k8s-data
exit
 
# Update minikube image in VirtualBox to mount  /wls-k8s-data
/wls-k8s-data --> wls-k8s-data
minikube ssh
ls /wls-k8s-data
exit
 
# Restart minikube
minikube stop
minikube start
```
# Change Permissions on Persistent Volume
By default (at least on Mac OS) the folders that get created on the persistent volume (e.g. domains) are not writeable, even though the parent folder is set to 777.

```bash
minikube ssh
sudo -s
umount /wls-k8s-data/
mount -t vboxsf -o rw,dmode=777,fmode=777 wls-k8s-data /wls-k8s-data
exit
exit
```

# Populate the Persistent Volume
Initialize the persistent volume with the scripts and applications that will be required.
```bash
export PVHOME=/wls-k8s-data/wls-k8s-mg
mkdir -p -m 777 $PVHOME
 
# Create the scripts folder and populate it
mkdir -p $PVHOME/scripts
cp scripts/create-domain.py $PVHOME/scripts
cp scripts/create-domain-job.sh $PVHOME/scripts
```

# Persistent Volume
Create the persistent volume and a claim against that volume

```bash
# Create the persistent volume, and a claim against it
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