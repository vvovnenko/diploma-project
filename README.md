# Diploma project

## 🚀 Команди запуску

**Запуск інфраструктури**

```bash
terraform init
terraform plan
terraform apply
```

**Видалення інфраструктури**
```bash
terraform destroy
```

**Вхід в AWS ECR (отримання токену логіну)**
```bash
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 731464279148.dkr.ecr.eu-north-1.amazonaws.com
```

**Білдимо Docker image**

```bash
docker build -t diploma-project:openswoole .  -f ./runtimes/openswoole/openswoole.Dockerfile
docker build -t diploma-project:swoole .  -f ./runtimes/swoole/swoole.Dockerfile
docker build -t diploma-project:nginx .  -f ./runtimes/nginx-phpfpm/nginx/nginx.Dockerfile
docker build -t diploma-project:phpfpm .  -f ./runtimes/nginx-phpfpm/phpfpm/phpfpm.Dockerfile
```

**Додаємо тег імеджу для пушу в ECR**
```bash
docker tag diploma-project:openswoole 731464279148.dkr.ecr.eu-north-1.amazonaws.com/diploma-ecr:openswoole
docker tag diploma-project:swoole 731464279148.dkr.ecr.eu-north-1.amazonaws.com/diploma-ecr:swoole
docker tag diploma-project:nginx 731464279148.dkr.ecr.eu-north-1.amazonaws.com/diploma-ecr:nginx
docker tag diploma-project:phpfpm 731464279148.dkr.ecr.eu-north-1.amazonaws.com/diploma-ecr:phpfpm
```

**Пушимо в ECR**
```bash
docker push --all-tags 731464279148.dkr.ecr.eu-north-1.amazonaws.com/diploma-ecr
```


**Додавання EKS кластеру в kubeconfig**
```bash
aws eks update-kubeconfig \
  --region eu-north-1 \
  --name eks-cluster-diploma
```

**Встановлення Helm**

OpenSwoole
```bash
helm upgrade --install openswoole ./openswoole -f ./values.yaml -f ./openswoole/values.yaml
```

Nginx+PHP-FPM
```bash
helm upgrade --install nginx-phpfpm ./nginx-phpfpm -f ./values.yaml -f ./nginx-phpfpm/values.yaml```
```

**Видалення Helm charts**

OpenSwoole
```bash
helm uninstall openswoole
```

Nginx+PHP-FPM
```bash
helm uninstall nginx-phpfpm 
```
