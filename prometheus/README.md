# Prometheus Deployment Example

## Overview

An example of how to deploy Promethues, Grafana & wls-exporter to a Kubernetes cluster

## Requirements

- Kubernetes 1.8.1
- Prometheus 1.7.1
- Grafana 4.4.3

## Example Files

### prometheus.yml
- Creates a deployment of prometheus 1.7.1
- Creates a service named "prometheus" that exposes the deployment as an externel endpoint on port 9090
- Defines the scraping configuration for prometheus.  The scraping definitions were taken from example files.

### persistent-volume.yml
This file is currently not used.  It contains the definition for a PersistentVolume and a PersistentVolumeClaim.

It appears that our PersistentVolume storage will require NFS, and that support is not yet configures for our Kubernetes cluster.

References to the storage defined in this file are currently commented out of prometheus-kubernetes.yml

### grafana-kubernetes.yml
- Creates a deployment of grafana 4.4.3
- Creates a service named "grafana" that exposes the deployment as an external endpoint on port 3000

## Startup the Environment
```bash
# Clone the source tree
git clone https://github.com/mgianatagh/wls-k8s-mg.git
cd wls-k8s-mg
 
# Startup the Kubernetes cluster
minikube start
minikube dashboard
```
## Deploy wls-exporter
```bash
kubectl create -f wls-exporter/k8s/wls-admin.yml
minikube service wls-admin-service --url
 
# Show wls-exporter
{wls-exporter-url}/wls-exporter
```

## Deploy Prometheus
```bash
kubectl create -f prometheus/prometheus.yml
 
# Obtain the URL of prometheus service and open in browser
minikube service prometheus --url
```
## Test the Deployment

Obtain the external endpoint of the service.  This can be found under the "Services" section of the kubernetes dashboard.

Click on the link to the external endpoint for the service named "prometheus".

You should see the Prometheus UI for Alerts, Graph, Status and Help.

Click on the metrics pulldown and select 'wls_scrape_cpu_seconds' and click 'execute'

## Deploy Grafana
```
kubectl create -f grafana-kubernetes.yml
```

## Configure Grafana
Obtain the external endpoint of the service.  This can be found under the "Services" section of the kubernetes dashboard.

Click on the link to the external endpoint for the service named "grafana".

Log into the service with username "admin" and password "pass".

Click "Add Data Source" and then connect Grafana to Prometheus by entering:
- Name:   Prometheus
- Type:   Prometheus
- Url:    http://prometheus:9090
- Access: Proxy

Click "Add" to save the data source

Click on the "Dashboards" tab.  

Click the "Import" button on the end of the line that says "Prometheus Stats"

Click the leftmost menu on the menu bar, and the select "Dashboards > Import".

Upload and import the file prometheus/grafana-config.json and select the data source you added in the previous step ("Prometheus"). It should generate dashboard named "WLS_Prometheus"


## Cleanup

```bash
kubectl delete -f wls-exporter/k8s/wls-admin.yml
kubectl delete -f prometheus/prometheus.yml


kubectl delete -f grafana-kubernetes.yml
kubectl delete -f prometheus-kubernetes.yml
```