# Actions for the Web Server Role
web_server_actions = [
  "s3:ListBucket",
  "s3:GetObject",
  "s3:GetObjectVersion",
  "s3:DeleteObject"
]

# Web Server EC2 Instance Specifications
web_instance_type = "t2.micro"
web_asg_min       = 1
web_asg_max       = 1
web_asg_desired   = 1