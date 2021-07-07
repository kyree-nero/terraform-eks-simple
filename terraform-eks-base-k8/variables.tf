variable "aws-region" {
    type        = string
}

variable "eks-cluster-name" {
  description = "AWS EKS cluster name"
  type        = string
}

variable "logging_enabled" {
  description = "logging enabled -- can be true or false"
  type        = string
}

variable "logging_type" {
  description = "logging type -- can be fluent-bit or fluentd"
  type        = string
}