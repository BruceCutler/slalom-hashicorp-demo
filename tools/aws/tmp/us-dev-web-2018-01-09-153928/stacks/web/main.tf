terraform {
  backend "s3" {}
}

variable "region" {}

variable "geo" {}

variable "target" {}

variable "stack" {}

variable "s3_bucket" {}

variable "web_instance_type" {}

variable "azs" {
  type = "list"
}

variable "web_asg_min" {}

variable "web_asg_max" {}

variable "web_asg_desired" {}

provider "aws" {
  region = "${var.region}"
}

module "web" {
  source            = "../../modules/web"
  region            = "${var.region}"
  geo               = "${var.geo}"
  target            = "${var.target}"
  stack             = "${var.stack}"
  s3_bucket         = "${var.s3_bucket}"
  azs               = "${var.azs}"
  web_instance_type = "${var.web_instance_type}"
  web_asg_min       = "${var.web_asg_min}"
  web_asg_max       = "${var.web_asg_max}"
  web_asg_desired   = "${var.web_asg_desired}"
}
