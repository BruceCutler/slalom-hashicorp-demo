variable "region" {}

variable "geo" {}

variable "target" {}

variable "bastion_instance_type" {}

variable "bastion_asg_min" {}

variable "bastion_asg_max" {}

variable "bastion_asg_desired" {}

variable "iam_instance_profile" {}

variable "security_groups" {}

variable "subnets" {
  type = "list"
}

module "bastion_launch_config" {
  source = "../../launch_config"
  region = "${var.region}"
  geo    = "${var.geo}"
  target = "${var.target}"
  instance_type = "${var.bastion_instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  security_groups = "${var.security_groups}"
}

module "bastion_asg" {
  source               = "../../asg"
  target               = "${var.target}"
  geo                  = "${var.geo}"
  launch_config        = "${module.bastion_launch_config.launch_config}"
  identifier           = "bastion"
  asg_min              = "${var.bastion_asg_min}"
  asg_max              = "${var.bastion_asg_max}"
  asg_desired          = "${var.bastion_asg_desired}"
  subnets              = ["${var.subnets}"]
}