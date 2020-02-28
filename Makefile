prereq:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	k get ns monitoring || k create ns monitoring

minikube:
	minikube start

prometheus: prereq
	helm upgrade --install prom stable/prometheus-operator --namespace monitoring

