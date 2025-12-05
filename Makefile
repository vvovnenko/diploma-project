ACCOUNT = 731464279148
REGION = eu-north-1
EKS_CLUSTER_NAME = eks-cluster-diploma
ECR_HOST = $(ACCOUNT).dkr.ecr.$(REGION).amazonaws.com
ECR_URL = $(ECR_HOST)/diploma-ecr
TERRAFORM_GLOBAL = -chdir=./terraform

AWK :=$(shell command -v awk 2> /dev/null)

.DEFAULT_GOAL := help
.PHONY: help

help: ## Show this help
ifndef AWK
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
else
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
endif

##
## Project setup
##-----------------------------------------
terraform-init: ## Terraform init
	terraform $(TERRAFORM_GLOBAL) init

terraform-plan: ## Terraform plan
	terraform $(TERRAFORM_GLOBAL) plan

terraform-apply: ## Terraform apply
	terraform $(TERRAFORM_GLOBAL) apply

terraform-destroy: ## Terraform destroy
	terraform $(TERRAFORM_GLOBAL) destroy

login-ecr: ## Login AWS ECR
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ECR_HOST)

kubeconfig-update: ## Add EKS cluster to the kubeconfig
	aws eks update-kubeconfig --region $(REGION) --name $(EKS_CLUSTER_NAME)

##
## FrankenPHP runtime
##-----------------------------------------
franken-deploy: ## Deploy FrankenPHP to the EKS cluster
	helm upgrade --install frankenphp ./charts/frankenphp -f ./charts/values.yaml -f ./charts/frankenphp/values.yaml

franken-delete: ## Delete FrankenPHP from the EKS cluster
	helm uninstall --ignore-not-found frankenphp

franken-redeploy: ## Redeploy FrankenPHP
franken-redeploy: franken-delete franken-deploy

##
## OpenSwoole runtime
##-----------------------------------------
openswoole-deploy: ## Deploy OpenSwoole to the EKS cluster
	helm upgrade --install openswoole ./charts/openswoole -f ./charts/values.yaml -f ./charts/openswoole/values.yaml

openswoole-delete: ## Delete OpenSwoole from the EKS cluster
	helm uninstall --ignore-not-found openswoole

openswoole-redeploy: ## Redeploy OpenSwoole
openswoole-redeploy: openswoole-delete openswoole-deploy

##
## Swoole runtime
##-----------------------------------------
swoole-deploy: ## Deploy Swoole to the EKS cluster
	helm upgrade --install swoole ./charts/swoole -f ./charts/values.yaml -f ./charts/swoole/values.yaml

swoole-delete: ## Delete Swoole from the EKS cluster
	helm uninstall --ignore-not-found swoole

swoole-redeploy: ## Redeploy Swoole
swoole-redeploy: swoole-delete swoole-deploy

##
## PHP-FPM runtime
##-----------------------------------------
fpm-deploy: ## Deploy PHP-FPM to the EKS cluster
	helm upgrade --install nginx-phpfpm ./charts/nginx-phpfpm -f ./charts/values.yaml -f ./charts/nginx-phpfpm/values.yaml

fpm-delete: ## Delete PHP-FPM from the EKS cluster
	helm uninstall --ignore-not-found nginx-phpfpm

fpm-redeploy: ## Redeploy PHP-FPM
fpm-redeploy: fpm-delete fpm-deploy


##
## Bench runner
##-----------------------------------------
bench-runner-deploy: ## Deploy Bench runner to the EKS cluster
	helm upgrade --install bench-runner ./charts/bench-runner  -f ./charts/values.yaml -f ./charts/bench-runner/values.yaml

bench-runner-delete: ## Delete Bench runner from the EKS cluster
	helm uninstall --ignore-not-found bench-runner

bench-runner-redeploy: ## Redeploy Bench runner
bench-runner-redeploy: bench-runner-delete bench-runner-deploy


