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

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "value for the zone where the GKE cluster will be created"
}


variable "vpc" {
  description = "Nome da VPC para o VM"
  default     = "vpc-project"
  type        = string
}

variable "subnet_vms" {
  description = "Subnet VM"
  default     = "sub-vms-project"
  type        = string
}


variable "machine_type" {
  description = "Tipo de máquina para os nodes"
  default     = "e2-standard-2"
  type        = string
}

variable "image_instance" {
  description = "Imagem do sistema operacional"
  type        = string
  default     = "ubuntu-2404-noble-amd64-v20250709"
}

variable "vm_name" {
  description = "Nome da VM"
  type        = string
  default     = "vm-vpn"
}
