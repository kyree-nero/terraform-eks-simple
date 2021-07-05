variable "custom_tags" {
  description = "AWS Custom tags"
  type        = map
}

variable "desired_number_nodes" {
  description = "Desired number of Kubernetes nodes in AWS Node Group"
  type        = number
}

variable "eks-cluster-name" {
  description = "AWS EKS cluster name"
  type        = string
}


variable "eks-cluster-arn" {
  description = "AWS EKS cluster arn"
  type        = string
}

variable "eks-cluster-node-group-arn" {
  description = "AWS EKS Node cluster arn"
  type        = string
}

variable "eks-worker-remote-source_security_group_ids" {
    description = "worker nodes sec groups"
    type        = list

}

variable "kubernetes-version" {
  description = "AWS EKS cluster Kubernetes version"
  type        = string
}


variable "max_number_nodes" {
  description = "Max number of Kubernetes nodes in AWS Node Group"
  type        = number
}

variable "min_number_nodes" {
  description = "Min number of Kubernetes nodes in AWS Node Group"
  type        = number
}

variable "nodes_instance_type" {
  description = "Nodes instance type"
  type        = string
}

variable "private_subnets" {
  description = "Subnets"
  type        = list
}

variable "public_subnets" {
  description = "Subnets"
  type        = list
}

variable "ssh_public_key_path" {
  description = "SSH public key path"
  type        = string
}

variable "tcp_ports" {
  description = "TCP port to be allowed by AWS Security Group"
  type        = list
}

