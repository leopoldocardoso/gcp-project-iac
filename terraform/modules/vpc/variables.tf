variable "project_id" {
  description = "The ID of the project in which the resources will be created"
  type        = string
  default     = "devops-464620"
}

variable "vpc" {
  type = object({
    name         = string
    routing_mode = string
    subnets = list(object({
      name                     = string
      ip_cidr_range            = string
      region                   = string
      private_ip_google_access = bool
    }))
  })
  default = {
    name         = "vpc-project"
    routing_mode = "GLOBAL"
    subnets = [
      {
        name                     = "sub-vms-project"
        ip_cidr_range            = "192.168.0.0/24"
        private_ip_google_access = true
        region                   = "us-central1"
      },
      {
        name                     = "sub-gke-project"
        ip_cidr_range            = "192.168.1.0/24"
        private_ip_google_access = true
        region                   = "us-central1"
      }
    ]
  }
}
