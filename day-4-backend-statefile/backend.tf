terraform {
  backend "s3" {
    bucket       = "rags-backend"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # Enables native S3 locking (Terraform 1.10+)
  }
}
