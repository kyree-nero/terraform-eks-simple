# AWS EKS node group
resource "aws_security_group" "eks_cluster_node_group" {
 name        = "EKSClusterNodeGroupSecurityGroup"
 description = "Allow TLS inbound traffic"
 vpc_id      = var.vpc_id
 ingress {

   description = "Allow incoming SSH traffic"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   # Please restrict your ingress to only necessary IPs and ports.
   # Opening to 0.0.0.0/0 can lead to security vulnerabilities.

   # This should be restricted to only ALLOWED IP Addresses
   cidr_blocks = [var.home_cidr] # add a CIDR block here

 }

 egress {
   description = "Allow all outbound traffic"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]

 }

 tags = merge({
   "kubernetes.io/cluster/${var.eks-cluster-name}" = "owned"
   },
   var.custom_tags
 )

}
