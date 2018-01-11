variable "geo" {}

variable "target" {}

variable "region" {}

variable "instance_type" {}

variable "iam_instance_profile" {}

variable "security_groups" {}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name = "name"
    values = ["amzn-ami-hvm-2017.09.1*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

data "template_file" "simple_userdata" {
  template = "${file("${path.module}/templates/init.tpl")}"
}

resource "aws_launch_configuration" "web_server_lc" {
  image_id             = "${data.aws_ami.amazon_linux.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  security_groups      = ["${var.security_groups}"]
  key_name             = "bcutler-inno-${var.region}"
  user_data            = "${data.template_file.simple_userdata.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

output "launch_config" {
  value = "${aws_launch_configuration.web_server_lc.id}"
}