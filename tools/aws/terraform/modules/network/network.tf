variable "region" {}

variable "target" {}

variable "stack" {}

variable "geo" {}

variable "bastion_instance_type" {}

variable "bastion_asg_min" {}

variable "bastion_asg_max" {}

variable "bastion_asg_desired" {}

variable "s3_bucket" {}

variable "cidr_block" {}

variable "azs" {
  type = "list"
}

variable "pub_sub_cidr" {
  type = "list"
}

variable "priv_sub_cidr" {
  type = "list"
}

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config {
    bucket = "${var.s3_bucket}"
    key    = "state/${var.target}-iam.tfstate"
    region = "${var.region}"
  }
}

module "vpc" {
  source       = "./vpc"
  region       = "${var.region}"
  target       = "${var.target}"
  stack        = "${var.stack}"
  cidr_block   = "${var.cidr_block}"
}

module "public_subnet" {
  source         = "./public_subnet"
  region         = "${var.region}"
  azs            = "${var.azs}"
  target         = "${var.target}"
  stack          = "${var.stack}"
  pub_sub_cidr   = "${var.pub_sub_cidr}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "private_subnet" {
  source          = "./private_subnet"
  region          = "${var.region}"
  azs             = "${var.azs}"
  target          = "${var.target}"
  stack           = "${var.stack}"
  priv_sub_cidr   = "${var.priv_sub_cidr}"
  vpc_id          = "${module.vpc.vpc_id}"
  igw_id          = "${module.public_subnet.igw_id}"
  pub_subnet_ids  = "${module.public_subnet.pub_subnet_ids}"
}

module "security_groups" {
  source = "./security_groups"
  region = "${var.region}"
  geo    = "${var.geo}"
  target = "${var.target}"
  stack  = "${var.stack}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "bastion" {
  source = "./bastion"
  region = "${var.region}"
  geo    = "${var.geo}"
  target = "${var.target}"
  bastion_instance_type = "${var.bastion_instance_type}"
  bastion_asg_min = "${var.bastion_asg_min}"
  bastion_asg_max = "${var.bastion_asg_max}"
  bastion_asg_desired = "${var.bastion_asg_desired}"
  iam_instance_profile = "${data.terraform_remote_state.iam.bastion_server_iam_instance_profile}"
  subnets = "${module.public_subnet.pub_subnet_ids}"
  security_groups = "${module.security_groups.bastion_sg}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "pub_subnet_ids" {
  value = "${module.public_subnet.pub_subnet_ids}"
}

output "igw_id" {
  value = "${module.public_subnet.igw_id}"
}

output "aws_rtb_id" {
  value = "${module.public_subnet.aws_rtb_id}"
}

output "priv_subnet_ids" {
  value = "${module.private_subnet.priv_subnet_ids}"
}

output "nat_gateway_id" {
  value = "${module.private_subnet.nat_gateway_id}"
}

output "nat_gateway_ip" {
  value = "${module.private_subnet.nat_gateway_ip}"
}

output "nat_gateway_cidr" {
  value = "${module.private_subnet.nat_gateway_cidr}"
}

output "route_table_id" {
  value = "${module.private_subnet.route_table_id}"
}


















