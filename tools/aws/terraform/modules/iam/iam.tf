variable "region" {}

variable "geo" {}

variable "target" {}

variable "identifier" {}

variable "policy_doc" {}

resource "aws_iam_role_policy" "server_iam_role_policy" {
  name = "${var.target}-${var.geo}-${var.identifier}-server-policy"
  role = "${aws_iam_role.server_role.id}"

  policy = "${var.policy_doc}"
}

resource "aws_iam_instance_profile" "server_iam_profile" {
  name  = "${var.target}-${var.geo}-${var.identifier}-server-profile"
  role = "${aws_iam_role.server_role.id}"
}

resource "aws_iam_role" "server_role" {
  name = "${var.target}-${var.geo}-${var.identifier}-server-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

output "server_iam_role" {
  value = "${aws_iam_role.server_role.id}"
}

output "server_iam_instance_profile" {
  value = "${aws_iam_instance_profile.server_iam_profile.id}"
}