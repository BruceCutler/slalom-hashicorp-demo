terraform {
  backend "s3" {}
}

variable "geo" {}

variable "region" {}

variable "target" {}

variable "stack" {}

variable "web_server_actions" {
  type = "list"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_iam_policy_document" "web_server_policy" {
  statement {
    actions = "${var.web_server_actions}"

    resources = [
      "*"
    ]
  }
}

module "iam" {
  source     = "../../modules/iam"
  region     = "${var.region}"
  geo        = "${var.geo}"
  target     = "${var.target}"
  policy_doc = "${data.aws_iam_policy_document.web_server_policy.json}"
}

output "web_server_iam_role" {
  value = "${module.iam.web_server_iam_role}"
}

output "web_server_iam_instance_profile" {
  value = "${module.iam.web_server_iam_instance_profile}"
}