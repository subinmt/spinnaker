# Spinnaker for AWS EKS

## Setup
You can use this module like below. This shows how to create the resources for spinnaker. This module will create vpc, subnets, iam policies and kubernetes cluster.
[This](main.tf) is the example of terraform configuration file to create a spinnaker on your AWS account. Check out and apply it using terraform command.

Run terraform, you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.:
```
terraform init
terraform plan -var-file tc1.tfvars
terraform apply -var-file tc1.tfvars
```
After then you will see so many resources like EKS, IAM, RDS, and others on AWS. For more information about role chaining to integrate `spinnaker managed roles` with `spinnaker role`, please visit the [Cloud Providers](https://github.com/Young-ook/terraform-aws-spinnaker/blob/main/README.md#cloud-providers) configuration. Follow the instructions to enable accounts for cloud provider integration.

## Clean up
Before you using terraform command to delete all resources, please check the [known issues](https://github.com/Young-ook/terraform-aws-spinnaker/tree/main#hangs-at-destroying) about uninstall.

Run terraform:
```
$ terraform destroy -var-file tc1.tfvars
```

