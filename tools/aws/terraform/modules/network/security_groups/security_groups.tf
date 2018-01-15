variable "region" {}

variable "geo" {}

variable "target" {}

variable "stack" {}

variable "vpc_id" {}

resource "aws_security_group" "bastion_sg" {
  name_prefix = "${var.target}-${var.geo}-slalom-hashicorp-bastion"
  description = "Allows inbound SSH traffic"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.target}-${var.geo}-slalom-hashicorp-bastion-sg"
  }  
}

resource "aws_security_group_rule" "ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_sg.id}"
}

resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_sg.id}"
}

output "bastion_sg" {
  value = "${aws_security_group.bastion_sg.id}"
}