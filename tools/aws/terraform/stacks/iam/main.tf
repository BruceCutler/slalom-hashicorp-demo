terraform {
  backend "s3" {}
}

variable "geo" {}

variable "region" {}

variable "target" {}

variable "stack" {}

variable "bastion_server_actions" {
  type = "list"
}

variable "web_server_actions" {
  type = "list"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_iam_policy_document" "bastion_server_policy" {
  statement {
    actions = "${var.bastion_server_actions}"

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "web_server_policy" {
  statement {
    actions = "${var.web_server_actions}"

    resources = [
      "*"
    ]
  }
}

module "bastion_iam" {
  source     = "../../modules/iam"
  region     = "${var.region}"
  geo        = "${var.geo}"
  target     = "${var.target}"
  identifier = "bastion"
  policy_doc = "${data.aws_iam_policy_document.bastion_server_policy.json}"
}

module "web_iam" {
  source     = "../../modules/iam"
  region     = "${var.region}"
  geo        = "${var.geo}"
  target     = "${var.target}"
  identifier = "web"
  policy_doc = "${data.aws_iam_policy_document.web_server_policy.json}"
}

output "bastion_server_iam_role" {
  value = "${module.bastion_iam.server_iam_role}"
}

output "bastion_server_iam_instance_profile" {
  value = "${module.bastion_iam.server_iam_instance_profile}"
}

output "web_server_iam_role" {
  value = "${module.web_iam.server_iam_role}"
}

output "web_server_iam_instance_profile" {
  value = "${module.web_iam.server_iam_instance_profile}"
}