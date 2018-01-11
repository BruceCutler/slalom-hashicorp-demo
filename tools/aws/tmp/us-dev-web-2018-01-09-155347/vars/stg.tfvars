# Actions for the Web Server Role
web_server_actions = [
  "s3:ListBucket",
  "s3:GetObject",
  "s3:GetObjectVersion"
]

# Web Server EC2 Instance Specifications
web_instance_type = "m4.large"
web_asg_min       = 2
web_asg_max       = 4
web_asg_desired   = 2