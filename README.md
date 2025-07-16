# Projeto de Infraestrutura GCP com Terraform, Ansible e Kubernetes

Este projeto demonstra a implementação de uma infraestrutura completa no Google Cloud Platform (GCP) utilizando as melhores práticas de Infrastructure as Code (IaC) e automação. A solução combina Terraform para provisionamento de infraestrutura, Ansible para configuração de máquinas virtuais, Kubernetes para orquestração de containers e uma aplicação web simples em Nginx.

## Visão Geral

O projeto está organizado em quatro componentes principais:

- **Terraform**: Provisionamento da infraestrutura base no GCP
- **Ansible**: Configuração automatizada de máquinas virtuais
- **Kubernetes**: Manifestos para deploy de aplicações
- **App**: Aplicação Hello World em Nginx

## Arquitetura da Infraestrutura

A infraestrutura provisionada no GCP inclui:

- **VPC (Virtual Private Cloud)** com duas subnets
- **Máquina Virtual** para workloads específicos
- **Cluster GKE (Google Kubernetes Engine)** para orquestração de containers



##  Estrutura do Projeto

```
├── ansible/                 # Playbooks Ansible para configuração de VMs
├── app/                     # Aplicação Hello World em Nginx
├── kubernetes/              # Manifestos Kubernetes
├── terraform/               # Configurações Terraform para infraestrutura GCP
│   ├── modules/             # Módulos Terraform reutilizáveis
│   │   ├── gcr-artifact/    # Módulo para Google Container Registry
│   │   ├── gke/             # Módulo para Google Kubernetes Engine
│   │   ├── instances/       # Módulo para instâncias de VM
│   │   └── vpc/             # Módulo para Virtual Private Cloud
│   ├── main.tf              # Configuração principal
│   └── variables.tf         # Variáveis do Terraform
├── .gitignore               # Arquivos ignorados pelo Git
└── README.md                # Este arquivo
```

## Terraform - Infraestrutura como Código

### Componentes Provisionados

#### 1. **VPC e Networking**
- Virtual Private Cloud (VPC) customizada
- Duas subnets para segmentação de rede
- Configurações de firewall e roteamento

#### 2. **Máquina Virtual**
- Instância Compute Engine
- Configuração de rede e segurança
- Preparada para configuração via Ansible

#### 3. **Cluster GKE**
- Google Kubernetes Engine cluster
- Nodes com endpoint privado para maior segurança
- Configuração otimizada para workloads containerizados


### Módulos Terraform

O projeto utiliza uma arquitetura modular para facilitar a manutenção e reutilização:

- **`modules/vpc/`**: Configuração da VPC e subnets
- **`modules/instances/`**: Definição das máquinas virtuais
- **`modules/gke/`**: Configuração do cluster Kubernetes
- **`modules/gcr-artifact/`**: Configuração do Google Container Registry

## Ansible - Configuração de Máquinas Virtuais

A pasta `ansible/` contém playbooks para configuração automatizada das máquinas virtuais provisionadas pelo Terraform.

### Funcionalidades
- Configuração inicial do sistema operacional
- Instalação de dependências necessárias
- Configuração de serviços e aplicações
- Hardening básico de segurança

##  Kubernetes - Orquestração de Containers

A pasta `kubernetes/` contém três arquivos de manifestos para deploy de aplicações no cluster GKE:

### Manifestos Incluídos
1. **Deployment**: Define a aplicação e suas réplicas
2. **Service**: Expõe a aplicação dentro do cluster
3. **Ingress/ConfigMap**: Configurações adicionais para acesso externo

### Características
- Configuração para alta disponibilidade
- Balanceamento de carga automático
- Escalabilidade horizontal

##  App - Aplicação Hello World

A pasta `app/` contém uma aplicação simples em Nginx que serve como exemplo de workload.

### Características
- Servidor web Nginx
- Página Hello World customizada
- Pronta para containerização
- Configuração otimizada para Kubernetes


##  Pré-requisitos

Antes de executar este projeto, certifique-se de ter instalado:

- **Terraform** (>= 1.0)
- **Ansible** (>= 2.9)
- **kubectl** (>= 1.20)
- **Google Cloud SDK** (gcloud CLI)
- **Docker** (para build de imagens)

### Configuração do GCP

1. Configure as credenciais do GCP:
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

2. Habilite as APIs necessárias:
```bash
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

##  Como Usar

### 1. Provisionamento da Infraestrutura

```bash
# Navegue para a pasta terraform
cd terraform

# Inicialize o Terraform
terraform init

# Revise o plano de execução
terraform plan

# Aplique as configurações
terraform apply
```

### 2. Configuração das VMs com Ansible

```bash
# Navegue para a pasta ansible
cd ansible

# Execute os playbooks
ansible-playbook -i inventory site.yml
```

### 3. Deploy no Kubernetes

```bash
# Configure o kubectl para o cluster GKE
gcloud container clusters get-credentials CLUSTER_NAME --zone=ZONE

# Aplique os manifestos
kubectl apply -f kubernetes/

# Verifique o status dos pods
kubectl get pods
```

### 4. Build e Deploy da Aplicação

```bash
# Navegue para a pasta app
cd app

# Build da imagem Docker
docker build -t gcr.io/YOUR_PROJECT_ID/hello-world:latest .

# Push para o Container Registry
docker push gcr.io/YOUR_PROJECT_ID/hello-world:latest
```

##  Comandos Úteis

### Terraform
```bash
# Visualizar recursos criados
terraform show

# Destruir infraestrutura
terraform destroy

# Validar configuração
terraform validate
```

### Kubernetes
```bash
# Verificar status do cluster
kubectl cluster-info

# Listar todos os recursos
kubectl get all

# Verificar logs de um pod
kubectl logs POD_NAME
```

### GCP
```bash
# Listar instâncias
gcloud compute instances list

# Verificar clusters GKE
gcloud container clusters list

# Verificar imagens no Container Registry
gcloud container images list
```

## Segurança

Este projeto implementa várias práticas de segurança:

- **Endpoints privados** no cluster GKE
- **Segmentação de rede** com VPC e subnets
- **Configuração de firewall** restritiva
- **Princípio do menor privilégio** nas permissões IAM

##  Notas Importantes

- Certifique-se de configurar as variáveis de ambiente necessárias antes da execução
- Monitore os custos do GCP durante o uso dos recursos

---



