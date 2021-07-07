variable "aws_region" {
    type        = string
}

variable "aws_account_number" {
    type        = string
}

variable "eks_cluster_node_group_name" {
    type        = string
}

variable "logging_type" {
  description = "logging type -- can be fluent-bit or fluentd"
  type        = string
}