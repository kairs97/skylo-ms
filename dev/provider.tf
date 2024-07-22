terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

