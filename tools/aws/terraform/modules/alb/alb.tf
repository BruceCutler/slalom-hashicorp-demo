variable "geo" {}

variable "target" {}

variable "security_groups" {}

variable "vpc_id" {}

variable "subnets" {
  type = "list"
}


resource "aws_lb" "application_load_balancer" {
  name = "${var.target}-${var.geo}-slalom-hashicorp-alb"
  internal    = false
  security_groups = ["${var.security_groups}"]
  subnets = ["${var.subnets}"]
  load_balancer_type = "application"

  tags {
    Name = "${var.target}-${var.geo}-slalom-hashicorp-alb"
  }
}

resource "aws_lb_target_group" "web_server_target_group" {
  name     = "${var.target}-${var.geo}-slalom-hashicorp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "web_server_alb_listener" {
  load_balancer_arn = "${aws_lb.application_load_balancer.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.web_server_target_group.arn}"
    type             = "forward"
  }
}

output "target_group" {
  value = "${aws_lb_target_group.web_server_target_group.id}"
}