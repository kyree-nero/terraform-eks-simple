aws_region = "eu-west-1"
custom_tags = {
  Name      = "diu-eks-cluster-tag"
  Terraform = "true"
  Delete    = "true"
}
desired_number_nodes = 2 # note that eks comes baked with pod packing severly limited.  Will need to look into custom templates to get rid of this...kubectl get nodes -o json | jq '.items[].status.capacity.pods' 
eks-cluster-name = "diu-eks-cluster"
home_cidr = "71.105.69.209/32"
kubernetes-version = "1.20"
max_number_nodes = 3
min_number_nodes = 1
nodes_instance_type = "t3.small"
ssh_public_key = "/Users/userx/key.myk3.pub"

tcp_ports = ["22", "30111", "30222", "30333", "8000"]