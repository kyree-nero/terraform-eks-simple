# EKS_CLUSTER_START
# ---------------------------------------------------------------------
#      Kubernetes AWS EKS cluster (Kubernetes control plane)
# ---------------------------------------------------------------------

# Uncomment to create AWS EKS cluster (Kubernetes control plane) - start
resource "aws_eks_cluster" "this" {
 name     = var.eks-cluster-name
 role_arn = var.eks-cluster-arn
 version  = var.kubernetes-version

 vpc_config {
   subnet_ids = [for subnet in [for value in var.subnets : value] : subnet.id]
 }

 # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
 # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.

  provisioner "local-exec" {
        command = "aws eks update-kubeconfig --kubeconfig ${path.cwd}/../k8s-${self.name}.yaml --name ${self.name}"
  }

  provisioner "local-exec" {
      when = destroy
      command = "rm -f ${path.cwd}/../k8s-${self.name}.yaml"
  }
}


# Uncomment to create AWS EKS cluster (Kubernetes control plane) - start
# EKS_CLUSTER_END






# EKS_NODE_GROUP_START
## ---------------------------------------------------------------------
##      Kubernetes AWS EKS node group (Kubernetes nodes)
## ---------------------------------------------------------------------

# Uncomment to create SSH key pair in AWS - start
resource "aws_key_pair" "this" {
 key_name   = "aws-eks-ssh-key"
 public_key = templatefile("${var.ssh_public_key_path}", {})
}
# Uncomment to create SSH key pair in AWS - end


# Uncomment to create AWS EKS cluster - node group - start
resource "aws_eks_node_group" "this" {
 cluster_name    = aws_eks_cluster.this.name
 node_group_name = "${var.eks-cluster-name}-node-group"
 node_role_arn = var.eks-cluster-node-group-arn

 subnet_ids      = [for subnet in [for value in var.subnets : value] : subnet.id]
 instance_types = ["t3.micro"]
 tags           = var.custom_tags

 scaling_config {
   desired_size = var.desired_number_nodes
   max_size     = var.max_number_nodes
   min_size     = var.min_number_nodes
 }

 remote_access {
   ec2_ssh_key               = aws_key_pair.this.key_name
   source_security_group_ids = var.eks-worker-remote-source_security_group_ids
   
 }

 # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
 # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
}
# Uncomment to create AWS EKS cluster (Kubernetes control plane) - end


# Uncomment to create Security Group rule for Kubernetes SSH port 22, NodePort 30111 - start

resource "aws_security_group_rule" "this" {
 for_each = toset(var.tcp_ports)

 type              = "ingress"
 from_port         = each.value
 to_port           = each.value
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_eks_node_group.this.resources[0].remote_access_security_group_id

 depends_on = [
   aws_eks_node_group.this

 ]
}
## Uncomment to create Security Group rule for Kubernetes NodePort 30111 - start
# EKS_NODE_GROUP_END