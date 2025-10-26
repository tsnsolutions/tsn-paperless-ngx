.PHONY: help install upgrade uninstall test lint template dry-run package

CHART_NAME := paperless-ngx
RELEASE_NAME := paperless
NAMESPACE := default
CHART_VERSION := 0.1.0

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: ## Add required helm repositories
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

install: deps ## Install the helm chart
	helm install $(RELEASE_NAME) ./helm-chart --namespace $(NAMESPACE) --create-namespace

install-prod: deps ## Install with production values
	helm install $(RELEASE_NAME) ./helm-chart \
		--namespace $(NAMESPACE) \
		--create-namespace \
		-f ./helm-chart/values-production.yaml

upgrade: ## Upgrade the helm chart
	helm upgrade $(RELEASE_NAME) ./helm-chart --namespace $(NAMESPACE)

upgrade-prod: ## Upgrade with production values
	helm upgrade $(RELEASE_NAME) ./helm-chart \
		--namespace $(NAMESPACE) \
		-f ./helm-chart/values-production.yaml

uninstall: ## Uninstall the helm chart
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

test: ## Run helm tests
	helm test $(RELEASE_NAME) --namespace $(NAMESPACE)

lint: ## Lint the helm chart
	helm lint ./helm-chart

template: ## Render templates locally
	helm template $(RELEASE_NAME) ./helm-chart

template-prod: ## Render templates with production values
	helm template $(RELEASE_NAME) ./helm-chart -f ./helm-chart/values-production.yaml

dry-run: deps ## Perform a dry-run installation
	helm install $(RELEASE_NAME) ./helm-chart \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--dry-run --debug

package: ## Package the helm chart
	helm package ./helm-chart

status: ## Show release status
	helm status $(RELEASE_NAME) --namespace $(NAMESPACE)

logs: ## Show application logs
	kubectl logs -f deployment/$(RELEASE_NAME)-$(CHART_NAME) --namespace $(NAMESPACE)

port-forward: ## Forward local port to service
	kubectl port-forward service/$(RELEASE_NAME)-$(CHART_NAME) 8080:8000 --namespace $(NAMESPACE)

get-password: ## Get the admin password
	kubectl get secret $(RELEASE_NAME)-$(CHART_NAME)-secret \
		--namespace $(NAMESPACE) \
		-o jsonpath="{.data.admin-password}" | base64 --decode && echo

clean-pvcs: ## Delete persistent volume claims (CAUTION: This will delete all data!)
	@echo "⚠️  WARNING: This will delete all persistent data!"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	kubectl delete pvc $(RELEASE_NAME)-$(CHART_NAME)-data --namespace $(NAMESPACE) || true
	kubectl delete pvc $(RELEASE_NAME)-$(CHART_NAME)-media --namespace $(NAMESPACE) || true