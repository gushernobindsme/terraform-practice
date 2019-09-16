terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket  = "gushernobindsme-terraform"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "gushernobindsme"
    encrypt = true
  }
}
