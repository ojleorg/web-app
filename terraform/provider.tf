provider "google" {
  project = "devops-364112"
  region  = "europe-west3"
}

# Backend configuration for state storage
terraform {
  backend "gcs" {
    bucket = "test-fww-tf"
    prefix = "terraform/state"
  }
}


