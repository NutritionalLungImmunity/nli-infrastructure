terraform {
  backend "s3" {
    bucket = "nwb-dev-terraform-state"
    key    = "fungal:girder"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  allowed_account_ids = ["094446577144"]
}

resource "aws_route53_zone" "fungal" {
  name = "computational-biology.org"
}

### VPC networking ###
data "aws_vpc" "fungal" {
  id = "vpc-2025865a"
}

data "aws_subnet" "fungal" {
  vpc_id = "${data.aws_vpc.fungal.id}"
  id = "subnet-eec459c0"
  # us-east-1a
}
