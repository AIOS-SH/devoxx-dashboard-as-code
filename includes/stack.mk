INGRESS_NGINX_CHART_VERSION ?= 4.0.1

create-cluster:
	kind create cluster --config configs/cluster.yml

delete-cluster:
	kind delete cluster

deploy-ingress-nginx:
	kubectl apply -f \
		https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

