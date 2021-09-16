JSONNET_URL   ?= https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz

DASHBOARDS   = $(shell ls dashboards | grep jsonnet)

include includes/helm.mk
include includes/monitoring.mk
include includes/stack.mk

all: prereq grafonnet-lib $(DASHBOARDS)

dashboards: $(DASHBOARDS)

bin/jsonnet:
	mkdir -p bin
	cd bin && wget -q -O - $(JSONNET_URL) | tar xfz -

json:
	mkdir json

%.jsonnet: json
	bin/jsonnet -J grafonnet-lib dashboards/$*.jsonnet > json/$*.json

update-dashboards: dashboards
	ansible-playbook -i localhost, update-dashboard.yml \
		-e ansible_python_interpreter=$(PYTHON) \
		-e dashboards=`ls json | sed 's/\.json$$//' | xargs echo | sed 's/ /,/g'`
