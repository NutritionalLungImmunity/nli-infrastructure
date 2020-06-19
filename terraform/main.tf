terraform {
  backend "s3" {
    bucket = "nli-tf-state"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  allowed_account_ids = ["463423358164"]
}

resource "aws_route53_zone" "domain" {
  name = "nutritionallungimmunity.org"
}
