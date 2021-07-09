aws_region = "eu-west-1"
custom_tags = {
  Name      = "diu-eks-cluster-tag"
  Terraform = "true"
  Delete    = "true"
}
desired_number_nodes = 2 # note that eks comes baked with pod packing severly limited.  Will need to look into custom templates to get rid of this...kubectl get nodes -o json | jq '.items[].status.capacity.pods' 
eks-cluster-name = "diu-eks-cluster"
home_cidr = <REPLACE WITH YOUR HOME CIDR>s
logging_enabled="true"
logging_type="fluentd"#"fluent-bit"# fluent-bit/fluentd/disabled
kubernetes-version = "1.20"
max_number_nodes = 3
min_number_nodes = 1
nodes_instance_type = "t3.small"#"t3.small"
ssh_public_key = "/Users/userx/key.myk3.pub"

tcp_ports = ["22"]