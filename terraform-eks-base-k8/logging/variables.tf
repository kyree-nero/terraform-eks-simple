variable "eks-cluster-name" {
  description = "AWS EKS cluster name"
  type        = string
}

variable "aws-region" {
  description = "AWS region"
  type        = string
}

variable "logging_type" {
  description = "logging type -- can be fluent-bit or fluentd"
  type        = string
}