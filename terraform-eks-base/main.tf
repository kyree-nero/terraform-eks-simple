

data "aws_availability_zones" "default" {
  state = "available"
}





module "iam" {
  source = "./iam"
  
}  


module "networking" {
  source = "./networking"
  
  custom_tags = var.custom_tags
  eks-cluster-name = var.eks-cluster-name

}


module "eks-networking" {
  source = "./eks-networking"

  custom_tags = var.custom_tags
  eks-cluster-name = var.eks-cluster-name
  home_cidr = var.home_cidr
  vpc_cidr_block = module.networking.vpc_cidr_block
  vpc_id = module.networking.vpc_id
}


module "eks" {
  source = "./eks"
  custom_tags = var.custom_tags
  desired_number_nodes = var.desired_number_nodes
  eks-cluster-arn = module.iam.eks-cluster-arn
  eks-cluster-name = var.eks-cluster-name
  eks-cluster-node-group-arn = module.iam.eks-cluster-node-group-arn
  eks-worker-remote-source_security_group_ids = module.eks-networking.eks_networking__remote_security_group_ids
  kubernetes-version = var.kubernetes-version
  max_number_nodes = var.max_number_nodes
  min_number_nodes = var.min_number_nodes
  nodes_instance_type = var.nodes_instance_type
  ssh_public_key_path = var.ssh_public_key
  #subnets = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  public_subnets = module.networking.public_subnets
  tcp_ports = var.tcp_ports

  depends_on = [
   module.iam.eks-cluster-AmazonEKSClusterPolicy,
   module.iam.eks-cluster-AmazonEKSServicePolicy,
   module.iam.eks-cluster-node-group-AmazonEKSWorkerNodePolicy,
   module.iam.eks-cluster-node-group-AmazonEKS_CNI_Policy,
   module.iam.eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly
  ]
}



