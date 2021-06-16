
data "aws_availability_zones" "default" {
  state = "available"
}

resource "aws_vpc" "this" {
    cidr_block = "10.123.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

     tags = merge({
          "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared", 
          "Name"="eks_vpc"
      }
     )
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "simulation_default_route" {
  route_table_id         = aws_vpc.this.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_subnet" "this" {
 count = 3

 availability_zone       = data.aws_availability_zones.default.names[count.index]
 cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 100 + count.index)
 vpc_id                  = aws_vpc.this.id
 map_public_ip_on_launch = true

 tags = merge({
   "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
   }
 )
}
