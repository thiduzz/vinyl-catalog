.DEFAULT_GOAL:=help
.PHONY=  apply-k8s
VAR_FILE = $(ENV).tfvars
KUBERNETES_CLUSTER_ID = 3a660f45-2710-424a-9706-872002af88f1

help: ## Prints the help about targets.
	@printf "Usage:             ENV=[\033[34mprod|stage|dev\033[0m] make [\033[34mtarget\033[0m]\n"
	@printf "Default:           \033[34m%s\033[0m\n" $(.DEFAULT_GOAL)
	@printf "Targets:\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " \033[34m%-17s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

init: ## Initialize Terraform project
	aws-vault exec vinyl-catalog -- terraform init -upgrade

apply: init ## Apply changes to Infrastructure with AWS Vault profile
	aws-vault exec vinyl-catalog -- terraform apply -var-file=$(VAR_FILE)

apply-base: init ## Apply changes to Infrastructure with AWS Vault profile
	aws-vault exec vinyl-catalog -- terraform apply -target="module.aws_resources" -target="module.scaleway_resources" -var-file=$(VAR_FILE)

apply-k8s: init ## Apply changes only to our Kubernetes Cluster without the need of AWS Vault profile
	terraform apply -target="module.k8s_resources" -var-file=$(VAR_FILE)

apply-refresh: init ## Refresh changes to Infrastructure with AWS Vault profile
	aws-vault exec vinyl-catalog -- terraform apply -refresh-only -var-file=$(VAR_FILE)

destroy: ## Remove all changes done to the Infrastructure with AWS Vault profile
	aws-vault exec vinyl-catalog -- terraform destroy -var-file=$(VAR_FILE)

kube-apply: ## Create all Kubernetes cluster resources
	kubectl apply -f ./k8s/manifests/backend.yaml
	kubectl apply -f ./k8s/manifests/frontend.yaml
	kubectl apply -f ./k8s/manifests/ingress.yaml

kube-redeploy: create-or-update-secrets ## Redeploy all pods
	kubectl rollout restart deployment backend

kube-destroy: ## Destroy all Kubernetes cluster resources
	kubectl delete -f ./k8s/manifests/backend.yaml
	kubectl delete -f ./k8s/manifests/frontend.yaml
	kubectl delete -f ./k8s/manifests/ingress.yaml

create-or-update-secrets: ## Read .env file and create Kubernetes Secrets
	kubectl delete secret regcred --ignore-not-found
	kubectl delete secret backend-secret --ignore-not-found
	kubectl create secret generic regcred --from-file=.dockerconfigjson=./docker-registry.json --type=kubernetes.io/dockerconfigjson
	kubectl create secret generic backend-secret --from-env-file=../services/api/.env.dist

update-kubeconfig: ## Update kubeconfig to connect to cluster
	scw -p vinyl-catalog k8s kubeconfig get $(KUBERNETES_CLUSTER_ID)
	scw -p vinyl-catalog k8s kubeconfig install $(KUBERNETES_CLUSTER_ID)