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

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "${var.s3_bucket}"
    key    = "state/${var.target}-network.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config {
    bucket = "${var.s3_bucket}"
    key    = "state/${var.target}-iam.tfstate"
    region = "${var.region}"
  }
}

data "template_file" "simple_userdata" {
  template = "${file("${path.module}/templates/init.tpl")}"
}

module "security_groups" {
  source = "./security_groups"
  region = "${var.region}"
  geo    = "${var.geo}"
  target = "${var.target}"
  stack  = "${var.stack}"
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"
}

module "web_alb" {
  source               = "../alb"
  target               = "${var.target}"
  geo                  = "${var.geo}"
  security_groups      = "${module.security_groups.elb_sg}"
  vpc_id               = "${data.terraform_remote_state.network.vpc_id}"
  subnets              = "${data.terraform_remote_state.network.pub_subnet_ids}"
}

module "web_launch_config" {
  source               = "../launch_config"
  target               = "${var.target}"
  region               = "${var.region}"
  geo                  = "${var.geo}"
  instance_type        = "${var.web_instance_type}"
  iam_instance_profile = "${data.terraform_remote_state.iam.web_server_iam_instance_profile}"
  security_groups      = "${module.security_groups.web_sg}"
  userdata             = "${data.template_file.simple_userdata.rendered}"
}

module "web_asg" {
  source               = "../asg"
  target               = "${var.target}"
  geo                  = "${var.geo}"
  launch_config        = "${module.web_launch_config.launch_config}"
  identifier           = "web"
  asg_min              = "${var.web_asg_min}"
  asg_max              = "${var.web_asg_max}"
  asg_desired          = "${var.web_asg_desired}"
  subnets              = "${data.terraform_remote_state.network.priv_subnet_ids}"
  target_group         = ["${module.web_alb.target_group}"]
}
