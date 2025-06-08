# Config
CLUSTER_NAME := personal-knowledge-tracker
NAMESPACE := default
KEYCLOAK_RELEASE := keycloak
KEYCLOAK_NAMESPACE := keycloak

# Tools
REQUIRED_TOOLS := kind kubectl helm docker

.PHONY: all check-tools cluster keycloak build load deploy setup clean

## Run full setup: build images, deploy everything
all: check-tools cluster keycloak build load deploy

check-tools: ## Check that required tools are installed
	@for tool in $(REQUIRED_TOOLS); do \
		if ! command -v $$tool >/dev/null; then \
		  echo "ERROR: $${tool} is not installed"; exit 1; \
		fi; \
	done;
	@echo "All required tools are installed"

cluster: ## Create a cluster with kind and set it as the current context
	@if ! kind get clusters | grep -q $(CLUSTER_NAME); then \
	  echo "Creating cluster..."; \
	  kind create cluster --name=$(CLUSTER_NAME); \
	else \
		echo "Cluster $(CLUSTER_NAME) already exists"; \
	fi;
	kubectl config use-context kind-$(CLUSTER_NAME)
	@echo "Current context is set to kind-$(CLUSTER_NAME)"

keycloak:
	@if ! helm status $(KEYCLOAK_RELEASE) -n $(KEYCLOAK_NAMESPACE) > /dev/null 2>&1; then \
		echo "🔐 Installing Keycloak..."; \
		kubectl create namespace $(KEYCLOAK_NAMESPACE) || true; \
		helm repo add codecentric https://codecentric.github.io/helm-charts; \
		helm repo update; \
		helm upgrade --install $(KEYCLOAK_RELEASE) codecentric/keycloak \
			--namespace $(KEYCLOAK_NAMESPACE) \
			--set keycloak.ingress.enabled=false \
			--set keycloak.service.type=ClusterIP \
			--set keycloak.extraEnv[0].name=KEYCLOAK_USER \
			--set keycloak.extraEnv[0].value=admin \
			--set keycloak.extraEnv[1].name=KEYCLOAK_PASSWORD \
			--set keycloak.extraEnv[1].value=admin; \
	else \
		echo "Keycloak already running";
	fi

clean:
	kind delete cluster --name $(CLUSTER_NAME)