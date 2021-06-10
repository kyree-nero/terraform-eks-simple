

# resource "aws_iam_role" "diu-eks-cluster" {
#  name = "diu-EksClusterIAMRole-tf"

#  assume_role_policy = <<POLICY
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "eks.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
# }

# POLICY
# }

# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.diu-eks-cluster.name
# }

# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-AmazonEKSServicePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#  role       = aws_iam_role.diu-eks-cluster.name
# }

# # IAM AWS role for Node Group
# resource "aws_iam_role" "diu-eks-cluster-node-group" {
#  name = "diu-EksClusterNodeGroup-tf"

#  assume_role_policy = jsonencode({
#    Statement = [{
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = {
#        Service = "ec2.amazonaws.com"
#      }
#    }]
#    Version = "2012-10-17"
#  })
# }

# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.diu-eks-cluster-node-group.name
# }

# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.diu-eks-cluster-node-group.name
# }

# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.diu-eks-cluster-node-group.name
# }





data "aws_vpc" "default" {
  default = "true"
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_availability_zones" "default" {
  state = "available"
}






# # AWS EKS node group
# resource "aws_security_group" "eks_cluster_node_group" {
#  name        = "EKSClusterNodeGroupSecurityGroup"
#  description = "Allow TLS inbound traffic"
#  vpc_id      = data.aws_vpc.default.id

#  ingress {

#    description = "Allow incoming SSH traffic"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    # Please restrict your ingress to only necessary IPs and ports.
#    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.

#    # This should be restricted to only ALLOWED IP Addresses
#    cidr_blocks = ["71.105.69.209/32"] # add a CIDR block here
#    # security_groups = list(var.alb_security_group_id)

#  }

#  egress {
#    description = "Allow all outbound traffic"
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]

#  }

#  tags = merge({
#    "kubernetes.io/cluster/${var.eks-cluster-name}" = "owned"
#    },
#    var.custom_tags
#  )

# }











# resource "aws_subnet" "this" {
#  count = 3

#  availability_zone       = data.aws_availability_zones.default.names[count.index]
#  cidr_block              = cidrsubnet(data.aws_vpc.default.cidr_block, 8, 100 + count.index)
#  vpc_id                  = data.aws_vpc.default.id
#  map_public_ip_on_launch = true

#  tags = merge({
#    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
#    },
#    var.custom_tags
#  )
# }





# # EKS_CLUSTER_START
# # ---------------------------------------------------------------------
# #      Kubernetes AWS EKS cluster (Kubernetes control plane)
# # ---------------------------------------------------------------------

# # Uncomment to create AWS EKS cluster (Kubernetes control plane) - start
# resource "aws_eks_cluster" "this" {
#  name     = var.eks-cluster-name
#  role_arn = aws_iam_role.diu-eks-cluster.arn
#  version  = var.kubernetes-version

#  vpc_config {
#    # subnet_ids = ["${aws_subnet.example1.id}", "${aws_subnet.example2.id}"]
#    # security_group_ids = list(aws_security_group.eks_cluster.id)
#    subnet_ids = [for subnet in [for value in aws_subnet.this : value] : subnet.id]
#  }

#  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#  depends_on = [
#    aws_iam_role_policy_attachment.diu-eks-cluster-AmazonEKSClusterPolicy,
#    aws_iam_role_policy_attachment.diu-eks-cluster-AmazonEKSServicePolicy,
#  ]
# }


# # Uncomment to create AWS EKS cluster (Kubernetes control plane) - start
# # EKS_CLUSTER_END






# # EKS_NODE_GROUP_START
# ## ---------------------------------------------------------------------
# ##      Kubernetes AWS EKS node group (Kubernetes nodes)
# ## ---------------------------------------------------------------------

# # Uncomment to create SSH key pair in AWS - start
# resource "aws_key_pair" "this" {
#  key_name   = "aws-eks-ssh-key"
#  public_key = templatefile("${var.ssh_public_key}", {})
# }
# # Uncomment to create SSH key pair in AWS - end


# # Uncomment to create AWS EKS cluster - node group - start
# resource "aws_eks_node_group" "this" {
#  cluster_name    = aws_eks_cluster.this.name
#  node_group_name = "${var.eks-cluster-name}-node-group"
#  node_role_arn   = aws_iam_role.diu-eks-cluster-node-group.arn
#  subnet_ids      = [for subnet in [for value in aws_subnet.this : value] : subnet.id]

#  instance_types = ["t3.micro"]
#  tags           = var.custom_tags

#  scaling_config {
#    desired_size = var.desired_number_nodes
#    max_size     = var.max_number_nodes
#    min_size     = var.min_number_nodes
#  }

#  remote_access {
#    ec2_ssh_key               = aws_key_pair.this.key_name
#    #source_security_group_ids = list(aws_security_group.eks_cluster_node_group.id)
#    source_security_group_ids = [aws_security_group.eks_cluster_node_group.id]
#  }

#  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#  depends_on = [
#    # aws_eks_cluster.this,
#    # aws_key_pair.this,
#    # aws_security_group.eks_cluster_node_group,
#    aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEKS_CNI_Policy,
#    aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly,
#  ]
# }
# # Uncomment to create AWS EKS cluster (Kubernetes control plane) - end


# # Uncomment to create Security Group rule for Kubernetes SSH port 22, NodePort 30111 - start

# resource "aws_security_group_rule" "this" {
#  for_each = toset(var.tcp_ports)

#  type              = "ingress"
#  from_port         = each.value
#  to_port           = each.value
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_eks_node_group.this.resources[0].remote_access_security_group_id

#  depends_on = [
#    aws_eks_node_group.this

#  ]
# }
# ## Uncomment to create Security Group rule for Kubernetes NodePort 30111 - start
# # EKS_NODE_GROUP_END
module "iam" {
  source = "./iam"
  
}  


module "networking" {
  source = "./networking"
  
  custom_tags = var.custom_tags
  eks-cluster-name = var.eks-cluster-name
  vpc_id = data.aws_vpc.default.id
  vpc_cidr_block = data.aws_vpc.default.cidr_block
}


module "eks-networking" {
  source = "./eks-networking"

  custom_tags = var.custom_tags
  eks-cluster-name = var.eks-cluster-name
  home_cidr = var.home_cidr
  vpc_cidr_block = data.aws_vpc.default.cidr_block
  vpc_id = data.aws_vpc.default.id
}


module "eks" {
  source = "./eks"
  custom_tags = var.custom_tags
  desired_number_nodes = var.desired_number_nodes
  #eks-cluster-arn = aws_iam_role.diu-eks-cluster.arn
  eks-cluster-arn = module.iam.eks-cluster-arn
  eks-cluster-name = var.eks-cluster-name
  #eks-cluster-node-group-arn = aws_iam_role.diu-eks-cluster-node-group.arn
  eks-cluster-node-group-arn = module.iam.eks-cluster-node-group-arn
  #eks-worker-remote-source_security_group_ids = [aws_security_group.eks_cluster_node_group.id]
  eks-worker-remote-source_security_group_ids = module.eks-networking.eks_networking__remote_security_group_ids
  kubernetes-version = var.kubernetes-version
  max_number_nodes = var.max_number_nodes
  min_number_nodes = var.min_number_nodes
  ssh_public_key_path = var.ssh_public_key
  #subnets = aws_subnet.this
  subnets = module.networking.subnets
  tcp_ports = var.tcp_ports

  depends_on = [
  #  aws_iam_role_policy_attachment.diu-eks-cluster-AmazonEKSClusterPolicy,
  #  aws_iam_role_policy_attachment.diu-eks-cluster-AmazonEKSServicePolicy,
  #  aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEKSWorkerNodePolicy,
  #  aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEKS_CNI_Policy,
  #  aws_iam_role_policy_attachment.diu-eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly
   module.iam.eks-cluster-AmazonEKSClusterPolicy,
   module.iam.eks-cluster-AmazonEKSServicePolicy,
   module.iam.eks-cluster-node-group-AmazonEKSWorkerNodePolicy,
   module.iam.eks-cluster-node-group-AmazonEKS_CNI_Policy,
   module.iam.eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly

  ]
}



