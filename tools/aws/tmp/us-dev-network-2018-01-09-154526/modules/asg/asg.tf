variable "geo" {}

variable "target" {}

variable "azs" {
  type = "list"
}

variable "launch_config" {}

variable "asg_min" {}

variable "asg_max" {}

variable "asg_desired" {}

variable "subnets" {
  type = "list"
}

variable "target_group" {
  type = "list"
}

resource "aws_autoscaling_group" "asg" {
  availability_zones   = "${var.azs}"
  name                 = "${var.target}-${var.geo}-slalom-hashicorp-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  launch_configuration = "${var.launch_config}"
  target_group_arns    = ["${var.target_group}"]
  vpc_zone_identifier  = ["${var.subnets}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.target}-${var.geo}-slalom-hashicorp"
    propagate_at_launch = true
  }
}