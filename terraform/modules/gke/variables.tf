variable "project_id" {
  type        = string
  default     = "devops-464620"
  description = "Project Name"
}


variable "region" {
  type        = string
  default     = "us-central1"
  description = "Região padrão para criação dos recursos GCP"
}

variable "cluster_zone" {
  type        = string
  default     = "us-central1-a"
  description = "value for the zone where the GKE cluster will be created"
}

variable "cluster_name" {
  description = "Nome do cluster GKE"
  default     = "gke-cluster-project"
  type        = string
}

variable "vpc" {
  description = "Nome da VPC para o GKE"
  default     = "vpc-project"
  type        = string
}

variable "subnet_gke" {
  description = "Subnet do node-pool"
  default     = "sub-gke-project"
  type        = string
}



variable "node_count" {
  description = "Número de nodes no cluster"
  default     = 1
  type        = number
}

variable "machine_type_node_dev" {
  description = "Tipo de máquina para os nodes"
  default     = "e2-medium"
  type        = string
}

variable "machine_type_node_prod" {
  description = "Tipo de máquina para os nodes"
  default     = "e2-medium"
  type        = string
}


variable "enable_nat" {
  description = "Habilitar Cloud NAT para acesso à internet"
  default     = false
  type        = bool
}

# Variável para os intervalos CIDR autorizados a acessar o master do cluster
variable "master_authorized_networks" {
  description = "Lista de CIDRs autorizados para acessar o master do GKE"
  type        = list(string)
  default     = ["192.168.29.0/24", "192.168.16.0/20", "34.71.188.94/32"]
}

# Variável para o bloco CIDR do master do GKE
variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28" # Intervalo CIDR configurado para o master
}

variable "pods_range_name" {
  description = "Nome do range secundário para IPs dos pods"
  type        = string
  default     = "gke-pods-range"
}

variable "services_range_name" {
  description = "Nome do range secundário para IPs dos services"
  type        = string
  default     = "gke-services-range"
}

variable "gke_admins" {
  type = list(string)
  default = [
    "lp.estudos.gcp@gmail.com",
  ]
}

variable "gcr_admins" {
  type = list(string)
  default = [
    "lp.estudos.gcp@gmail.com",
  ]
}
