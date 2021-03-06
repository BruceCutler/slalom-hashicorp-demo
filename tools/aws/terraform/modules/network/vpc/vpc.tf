variable "region" {}

variable "target" {}

variable "stack" {}

variable "cidr_block" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags {
    Name   = "vpc-slalom-hashicorp-${var.target}"
    Target = "${var.target}"
    Owner = "BruceCutler"
  }
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}