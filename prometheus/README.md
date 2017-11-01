# Prometheus Deployment Example

## Overview

An example of how to deploy Promethues, Grafana & wls-exporter to a Kubernetes cluster

## Test Environment

- minikube 0.23.0
- prometheus 1.8.1
- alertmanager 0.9.1
- grafana 4.6.1

## Startup the Environment
```bash
# Clone the source tree
git clone https://github.com/mgianatagh/wls-k8s-mg.git
cd wls-k8s-mg
 
# Startup the Kubernetes cluster
minikube start
minikube dashboard
eval $(minikube docker-env --shell=bash)
```
## Deploy wls-exporter
```bash
kubectl create -f wls-exporter/k8s/wls-admin.yml
minikube service wls-admin-service --url
 
# Connect to wls-exporter in a browser to verify the service is running
{wls-exporter-url}/wls-exporter
```

## Deploy Prometheus
```bash
kubectl create -f prometheus/prometheus.yml
 
# Obtain the URL of prometheus service
minikube service prometheus --url
 
# Open prometheus in a browser
minikube service prometheus
```
## Test the Deployment

Obtain the external endpoint of the service and open it in a browser.

You should see the Prometheus UI for Alerts, Graph, Status and Help.

Click on the metrics pulldown and select 'wls_scrape_cpu_seconds' and click 'execute'

## Deploy Grafana
```bash
kubectl create -f prometheus/grafana.yml
 
# Obtain the URL of grafana service
minikube service grafana --url
 
# Open grafana in a browser
minikube service grafana
```

## Configure Grafana
Log into the service with username "admin" and password "pass".

Click "Add Data Source" and then connect Grafana to Prometheus by entering:
- Name:   Prometheus
- Type:   Prometheus
- Url:    {output of minikube service prometheus --url}
- Access: Proxy

Click "Add" to save the data source

Click on the "Dashboards" tab.  

Click the "Import" button on the end of the line that says "Prometheus Stats"

Click the leftmost menu on the menu bar, and the select "Dashboards > Import".

Upload and import the file prometheus/grafana-config.json and select the data source you added in the previous step ("Prometheus"). It should generate dashboard named "WLS_Prometheus"


## Cleanup

```bash
kubectl delete -f prometheus/grafana.yml
kubectl delete -f prometheus/prometheus.yml
kubectl delete -f wls-exporter/k8s/wls-admin.yml
```