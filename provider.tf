provider "aws" {
  version = ">= 2.28.1"
  region  = "ap-northeast-1"
  profile = "gushernobindsme"
}

provider "github" {
  version      = "~> 2.2"
  organization = "gushernobindsme"
}
