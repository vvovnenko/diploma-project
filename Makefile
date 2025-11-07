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
franken-build: ## Build FrankenPHP image
	docker build -t diploma-project:frankenphp .  -f ./runtimes/frankenphp/frankenphp.Dockerfile

franken-tag: ## Add tag to the FrankenPHP image
	docker tag diploma-project:frankenphp $(ECR_URL):frankenphp

franken-push: ## Push FrankenPHP image
	docker push $(ECR_URL):frankenphp

franken-deploy: ## Deploy FrankenPHP to the EKS cluster
	helm upgrade --install frankenphp ./charts/frankenphp -f ./charts/values.yaml -f ./charts/frankenphp/values.yaml

franken-delete: ## Delete FrankenPHP from the EKS cluster
	helm uninstall --ignore-not-found frankenphp

franken-redeploy: ## Redeploy FrankenPHP
franken-redeploy: franken-delete franken-deploy

franken-install: ## Delete, Build, push and deploy FrankenPHP
franken-install: franken-delete franken-build franken-tag franken-push franken-deploy

##
## OpenSwoole runtime
##-----------------------------------------
openswoole-build: ## Build OpenSwoole image
	docker build -t diploma-project:openswoole .  -f ./runtimes/openswoole/openswoole.Dockerfile

openswoole-tag: ## Add tag to the OpenSwoole image
	docker tag diploma-project:openswoole $(ECR_URL):openswoole

openswoole-push: ## Push OpenSwoole image
	docker push $(ECR_URL):openswoole

openswoole-deploy: ## Deploy OpenSwoole to the EKS cluster
	helm upgrade --install openswoole ./charts/openswoole -f ./charts/values.yaml -f ./charts/openswoole/values.yaml

openswoole-delete: ## Delete OpenSwoole from the EKS cluster
	helm uninstall --ignore-not-found openswoole

openswoole-redeploy: ## Redeploy OpenSwoole
openswoole-redeploy: openswoole-delete openswoole-deploy

openswoole-install: ## Delete, Build, push and deploy OpenSwoole
openswoole-install: openswoole-delete openswoole-build openswoole-tag openswoole-push openswoole-deploy

##
## Swoole runtime
##-----------------------------------------
swoole-build: ## Build Swoole image
	docker build -t diploma-project:swoole .  -f ./runtimes/swoole/swoole.Dockerfile

swoole-tag: ## Add tag to the Swoole image
	docker tag diploma-project:swoole $(ECR_URL):swoole

swoole-push: ## Push Swoole image
	docker push $(ECR_URL):swoole

swoole-deploy: ## Deploy Swoole to the EKS cluster
	helm upgrade --install swoole ./charts/swoole -f ./charts/values.yaml -f ./charts/swoole/values.yaml

swoole-delete: ## Delete Swoole from the EKS cluster
	helm uninstall --ignore-not-found swoole

swoole-redeploy: ## Redeploy Swoole
swoole-redeploy: swoole-delete swoole-deploy

swoole-install: ## Delete, Build, push and deploy Swoole
swoole-install: swoole-delete swoole-build swoole-tag swoole-push swoole-deploy

##
## PHP-FPM runtime
##-----------------------------------------
fpm-build: ## Build PHP-FPM images
	( \
	  docker build -t diploma-project:nginx .  -f ./runtimes/nginx-phpfpm/nginx/nginx.Dockerfile && \
	  docker build -t diploma-project:phpfpm .  -f ./runtimes/nginx-phpfpm/phpfpm/phpfpm.Dockerfile \
	)

fpm-tag: ## Add tag to the PHP-FPM images
	( \
	  docker tag diploma-project:nginx $(ECR_URL):nginx && \
	  docker tag diploma-project:phpfpm $(ECR_URL):phpfpm \
	)

fpm-push: ## Push PHP-FPM images
	( \
	  docker push $(ECR_URL):nginx && \
	  docker push $(ECR_URL):phpfpm \
	)

fpm-deploy: ## Deploy PHP-FPM to the EKS cluster
	helm upgrade --install nginx-phpfpm ./charts/nginx-phpfpm -f ./charts/values.yaml -f ./charts/nginx-phpfpm/values.yaml

fpm-delete: ## Delete PHP-FPM from the EKS cluster
	helm uninstall --ignore-not-found nginx-phpfpm

fpm-redeploy: ## Redeploy PHP-FPM
fpm-redeploy: fpm-delete fpm-deploy

fpm-install: ## Delete, Build, push and deploy PHP-FPM
fpm-install: fpm-delete fpm-build fpm-tag fpm-push fpm-deploy


##
## Bench runner
##-----------------------------------------
bench-runner-build: ## Build Bench runner image
	docker build -t diploma-project:bench-runner .  -f ./runtimes/bench-runner/Dockerfile

bench-runner-tag: ## Add tag to the Bench runner image
	docker tag diploma-project:bench-runner $(ECR_URL):bench-runner

bench-runner-push: ## Push Bench runner image
	docker push $(ECR_URL):bench-runner

bench-runner-deploy: ## Deploy Bench runner to the EKS cluster
	helm upgrade --install bench-runner ./charts/bench-runner  -f ./charts/values.yaml -f ./charts/bench-runner/values.yaml

bench-runner-delete: ## Delete Bench runner from the EKS cluster
	helm uninstall --ignore-not-found bench-runner

bench-runner-redeploy: ## Redeploy Bench runner
bench-runner-redeploy: bench-runner-delete bench-runner-deploy

bench-runner-install: ## Delete, Build, push and deploy Bench runner
bench-runner-install: bench-runner-delete bench-runner-build bench-runner-tag bench-runner-push bench-runner-deploy


