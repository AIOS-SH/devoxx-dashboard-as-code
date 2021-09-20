
chart-repos:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

prereq: chart-repos

deploy-prom: prereq
	helm $(HELM_UPGRADE) prom prometheus-community/kube-prometheus-stack \
		--namespace monitoring $(PROM_OPTIONS) -f configs/prometheus-operator.yml

deploy-blackbox:
	helm $(HELM_UPGRADE) blackbox prometheus-community/prometheus-blackbox-exporter --namespace monitoring

deploy-probes:
	helm $(HELM_UPGRADE) probes charts/probes --namespace monitoring