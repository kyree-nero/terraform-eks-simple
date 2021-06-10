output "eks_networking__remote_security_group_ids" {
  description = "AWS vpc id"
  value       = [aws_security_group.eks_cluster_node_group.id]
}

