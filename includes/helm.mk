HELM_INSTALL  ?= false
HELM_UPGRADE  ?= $(shell $(HELM_INSTALL) || echo diff) upgrade --install $(shell $(HELM_INSTALL) || echo -C 5) \
				 $(shell $(HELM_INSTALL) && echo "--create-namespace")
