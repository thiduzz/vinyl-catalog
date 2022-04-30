.DEFAULT_GOAL:=help

VAR_FILE = $(ENV).tfvars
KUBERNETES_CLUSTER_ID =

help: ## Prints the help about targets.
	@printf "Usage:             ENV=[\033[34mprod|stage|dev\033[0m] make [\033[34mtarget\033[0m]\n"
	@printf "Default:           \033[34m%s\033[0m\n" $(.DEFAULT_GOAL)
	@printf "Targets:\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " \033[34m%-17s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

init: ## Initialize Terraform project
	terraform init

apply: init ## Apply changes to Infrastructure
	terraform apply -var-file=$(VAR_FILE)

destroy: ## Remove all changes done to the Infrastructure
	terraform destroy -var-file=$(VAR_FILE)

update-kubeconfig: ## Update kubeconfig to connect to cluster
	scw k8s kubeconfig get $(KUBERNETES_CLUSTER_ID)
	scw k8s kubeconfig install $(KUBERNETES_CLUSTER_ID)