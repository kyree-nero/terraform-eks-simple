aws_region = "eu-west-1"
custom_tags = {
  Name      = "diu-eks-cluster-tag"
  Terraform = "true"
  Delete    = "true"
}
desired_number_nodes = 2
eks-cluster-name = "diu-eks-cluster"
home_cidr = <REPLACE WITH YOUR HOME CIDR>
kubernetes-version = "1.19"
kubernetes-version = "1.20"
max_number_nodes = 3
min_number_nodes = 1
ssh_public_key = "/Users/userx/key.myk3.pub"

tcp_ports = ["22", "30111", "30222", "30333", "8000"]