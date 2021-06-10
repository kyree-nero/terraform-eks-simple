output "eks-cluster-AmazonEKSClusterPolicy" {
    value = aws_iam_role_policy_attachment.diu-eks-cluster-AmazonEKSClusterPolicy
}

output "eks-cluster-AmazonEKSServicePolicy" {
    value = aws_iam_role_policy_attachment.diu-eks-cluster-AmazonEKSServicePolicy
}

output "eks-cluster-node-group-AmazonEKSWorkerNodePolicy" {
    value = aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEKSWorkerNodePolicy
}

output "eks-cluster-node-group-AmazonEKS_CNI_Policy" {
    value = aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEKS_CNI_Policy
}

output "eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly" {
    value = aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly
}

output "eks-cluster-node-group-arn" {
    value = aws_iam_role.diu-eks-cluster-node-group.arn
}

output "eks-cluster-arn" { 
    value = aws_iam_role.diu-eks-cluster.arn
}