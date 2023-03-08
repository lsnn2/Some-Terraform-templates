terraform {
  backend "s3" {
    bucket = "terra-state-jenkins"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}