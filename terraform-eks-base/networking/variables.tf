variable "custom_tags" {
  description = "AWS Custom tags"
  type        = map
}


variable "eks-cluster-name" {
  description = "AWS EKS cluster name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "cidr block"
  type        = string
}


variable "vpc_id" {
  description = "vpc id"
  type        = string
}

