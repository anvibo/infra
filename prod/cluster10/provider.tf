provider "google" {
  credentials = "${file("../../creds/anvibo-gcp-f5f9b5100748.json")}"
  project     = "anvibo-gcp"
  region      = "europe-west4"
  zone        = "europe-west4-a"
}
terraform {
  backend "gcs" {
    bucket = "anvibo-terraform-states"
    prefix = "prod/cluster10/k8s"
    credentials = "../../creds/anvibo-gcp-f5f9b5100748.json"
  }
}