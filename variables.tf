# Variables for providing to module fixture codes

### aws credential
variable "aws_account_id" {
  description = "The aws account id for the tf backend creation (e.g. 857026751867)"
  type        = string
}

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
}

variable "azs" {
  description = "A list of availability zones for the vpc to deploy resources"
  type        = list(string)
}

variable "cidr" {
  description = "The list of CIDR blocks to allow ingress traffic for db access"
  type        = string
}

### kubernetes cluster
variable "kubernetes_version" {
  description = "The target version of kubernetes"
  type        = string
}

variable "kubernetes_node_groups" {
  description = "EKS managed node groups definition"
  default     = []
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
  default     = "spinnaker"
}
