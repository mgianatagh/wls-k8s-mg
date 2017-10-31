# Example: Deploy WebLogic to K8S and monitor with Prometheus and Grafana
This is a simple example of deploying WebLogic to Kubernetes and configuring Prometheus and Grafana to monitor information from WebLogic.
 
The basic flow of this example is:
* Use WebLogic 12.2.1.2 image to build a new Docker image with pre-built domain and the wls-exporter application deployed
* Deploy the updated Docker image to Kubernetes
* Deploy Prometheus, configure a datasource, and select some wls data to scrape
* Deploy and configure Grafana
* See dashboard graphs actively logging data

## WLS Exporter

The WLS Prometheus exporter is archived on GitHub. To create the web app, clone and the build the exporter here:

```bash
git clone https://github.com/russgold/wls-exporter.git
cd wls-exporter
mvn clean install
cd webapp
mvn clean package -Dconfiguration=$WLS-K8S/wls-exporter/metrics.yml
```

(where $WLS-K8S is the full path to wls-kubernetes/examples

This will create webapp/target/wls-exporter.war, which should be copied to wls-kubernetes/examples/wls-exporter/apps/

## Build Docker Image

```bash
# Build a new docker images that will be named wls-exporter
docker build -t wls-export -f Dockerfile .
```

### Validate Docker Image
If you want to validate the docker image before deploying it to Kubernetes, do the following:

```bash
# Start the container
docker run -d -p 7001:7001 wls-export
 
# Connect to weblogic console via browser and login as weblogic/Welcome1
# It may take a couple of minutes before the console is available
http://localhost:7001/console
 
# Click on "Deployments" from side panel, you should see the wls-exporter application in state "active"
 
# Connect to the wls-exporter application.  The banner of the page returned will be "This is the Weblogic Prometheus Exporter."
http://localhost:7001/wls-exporter
 
# Click the "metrics" link to view the metrics. You will be prompted for the username and password: weblogic/Welcome1
# A list of all the metrics will be displayed
 
# When done kill and remove the running container
docker kill <container-id>
docker rm <container-id>
```

## Push Docker Image
Push the docker image to the repository

```bash
docker tag wls-export mgianatadkr/docker.io:wls-export
docker push mgianatadkr/docker.io:wls-export
```
## Start the Admin Server Service
Deploy the Docker image to Kubernetes and start the admin server.  The wls-exporter application will also be started.

```bash
kubectl create -f k8s/wls-admin.yml
```
## Prometheus and Grafana
Follow the readme in examples/prometheus to deploy and configure prometheus and grafana.

## Cleanup
```bash
kubectl delete -f k8s/wls-admin.yml
```