variable "region" {}

variable "geo" {}

variable "target" {}

variable "stack" {}

variable "vpc_id" {}

resource "aws_security_group" "elb_sg" {
  name_prefix = "${var.target}-${var.geo}-slalom-hashicorp-elb"
  description = "Allows inbound HTTP and HTTPS traffic"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.target}-${var.geo}-slalom-hashicorp-elb-sg"
  }  
}

resource "aws_security_group_rule" "http_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elb_sg.id}"
}

resource "aws_security_group_rule" "elb_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elb_sg.id}"
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "${var.target}-${var.geo}-slalom-hashicorp-web-server"
  description = "Allows inbound from the ELB Security Group"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.target}-${var.geo}-slalom-hashicorp-web-server-sg"
  }
}

resource "aws_security_group_rule" "inbound_from_elb" {
  type      = "ingress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.elb_sg.id}"
  security_group_id = "${aws_security_group.web_server_sg.id}"
}

resource "aws_security_group_rule" "web_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web_server_sg.id}"
}

output "web_sg" {
  value = "${aws_security_group.web_server_sg.id}"
}

output "elb_sg" {
  value = "${aws_security_group.elb_sg.id}"
}

