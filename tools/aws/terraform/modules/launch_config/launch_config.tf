variable "geo" {}

variable "target" {}

variable "region" {}

variable "instance_type" {}

variable "iam_instance_profile" {}

variable "security_groups" {}

variable "userdata" {
  default = ""
}

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

resource "aws_launch_configuration" "launch_config" {
  image_id             = "${data.aws_ami.amazon_linux.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  security_groups      = ["${var.security_groups}"]
  key_name             = "bcutler-inno-${var.region}"
  user_data            = "${var.userdata}"

  lifecycle {
    create_before_destroy = true
  }

}

output "launch_config" {
  value = "${aws_launch_configuration.launch_config.id}"
}