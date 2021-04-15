name   = "spinnaker-crp"
aws_region         = "us-east-1"
azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
cidr               = "172.31.0.0/16"
kubernetes_version = "1.19"
aws_account_id = "113312902026"
kubernetes_node_groups = [
  {
    name          = "default"
    instance_type = "m5.large"
    min_size      = "1"
    max_size      = "3"
    desired_size  = "2"
  }
]
