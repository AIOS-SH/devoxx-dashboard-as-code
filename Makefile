DASHBOARDS   = $(shell ls dashboards | grep "jsonnet$$")

GOPATH ?= bin
JSONNET ?= $(GOPATH)/bin/jsonnet

export GOPATH

include includes/helm.mk
include includes/monitoring.mk
include includes/stack.mk

all: prereq grafonnet-lib $(DASHBOARDS)

dashboards: $(DASHBOARDS)

$(GOPATH)/bin:
	mkdir -p $(GOPATH)/bin

$(JSONNET): $(GOPATH)/bin
	go install github.com/google/go-jsonnet/cmd/jsonnet@latest
	go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest

prereq: chart-repos $(JSONNET)

json:
	mkdir json

%.jsonnet: json
	$(JSONNET) -J grafonnet-lib -J vendor dashboards/$*.jsonnet > charts/dashboards/files/$*.json

local-dashboards: dashboards
	sudo cp charts/dashboards/files/* /var/lib/grafana/dashboards/

continous-dashboards:
	while inotifywait -e close_write dashboards; do make local-dashboards ; done

deploy-dashboards: dashboards
	helm $(HELM_UPGRADE) dashboards charts/dashboards --namespace monitoring

clean-dashboards:
	rm -f charts/dashboards/files/*

clean-local-dashboards:
	sudo rm -f /var/lib/grafana/dashboards/*

clean: clean-dashboards clean-local-dashboards
