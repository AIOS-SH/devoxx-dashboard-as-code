IP             = $(shell minikube ip)
GRAFANA_URL    = grafana.$(IP).nip.io
PROMETHEUS_URL = prometheus.$(IP).nip.io

PROM_OPTIONS = --set grafana.ingress.hosts[0]=$(GRAFANA_URL) --set prometheus.ingress.hosts[0]=$(PROMETHEUS_URL)

prereq:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	k get ns monitoring || k create ns monitoring

prom: prereq
	helm upgrade --install prom stable/prometheus-operator --namespace monitoring $(PROM_OPTIONS) -f prometheus-operator.yml

start:
	minikube start
stop:
	minikube stop
