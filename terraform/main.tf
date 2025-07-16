terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.42.0"
    }
  }

  backend "gcs" {
    bucket = "iacterraformstate"
    prefix = "terraform/iac-tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
}

module "instances" {
  source     = "./modules/instances"
  depends_on = [module.vpc]
}


module "gke" {
  source = "./modules/gke"

  project_id = var.project_id
  region     = var.region
  depends_on = [module.vpc]
}




module "gcr-artifact" {
  source = "./modules/gcr-artifact"
}

