variable "region" {}

variable "geo" {}

variable "target" {}

variable "policy_doc" {}

resource "aws_iam_role_policy" "web_server_iam_role_policy" {
  name = "${var.target}-${var.geo}-web-server-policy"
  role = "${aws_iam_role.web_server_role.id}"

  policy = "${var.policy_doc}"
}

resource "aws_iam_instance_profile" "web_server_iam_profile" {
  name  = "${var.target}-${var.geo}-web-server-profile"
  role = "${aws_iam_role.web_server_role.id}"
}

resource "aws_iam_role" "web_server_role" {
  name = "${var.target}-${var.geo}-web-server-role"

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

output "web_server_iam_role" {
  value = "${aws_iam_role.web_server_role.id}"
}

output "web_server_iam_instance_profile" {
  value = "${aws_iam_instance_profile.web_server_iam_profile.id}"
}