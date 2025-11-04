# Diploma project

## 🚀 Команди запуску

**Запуск інфраструктури**

```bash
make terraform-init
make terraform-plan
make terraform-apply
```

**Видалення інфраструктури**
```bash
make terraform-destroy
```

**Вхід в AWS ECR (отримання токену логіну)**
```bash
make login-ecr
```

**Додавання EKS кластеру в kubeconfig**
```bash
make kubeconfig-update
```

**Install PHP-FPM runtime in the EKS cluster**
```bash
make fpm-install
```

**Install OpenSwoole runtime in the EKS cluster**
```bash
make openswoole-install
```

**Install FrankenPHP runtime in the EKS cluster**
```bash
make franken-install
```
