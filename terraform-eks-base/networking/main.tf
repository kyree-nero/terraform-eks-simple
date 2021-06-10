
data "aws_availability_zones" "default" {
  state = "available"
}

resource "aws_subnet" "this" {
 count = 3

 availability_zone       = data.aws_availability_zones.default.names[count.index]
 #cidr_block              = cidrsubnet(data.aws_vpc.default.cidr_block, 8, 100 + count.index)
 cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 100 + count.index)
 #vpc_id                  = data.aws_vpc.default.id
 vpc_id                  = var.vpc_id
 map_public_ip_on_launch = true

 tags = merge({
   "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
   },
   var.custom_tags
 )
}
