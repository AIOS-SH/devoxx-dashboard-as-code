
chart-repos:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

prereq: chart-repos

deploy-prom: prereq
	helm $(HELM_UPGRADE) prom prometheus-community/kube-prometheus-stack \
		--namespace monitoring $(PROM_OPTIONS) -f config/prometheus-operator.yml

deploy-blackbox:
	helm $(HELM_UPGRADE) blackbox prometheus-community/prometheus-blackbox-exporter --namespace monitoring
