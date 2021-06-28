
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


## PUBLIC SUBNETS

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# resource "aws_route" "simulation_default_route" {
#   route_table_id         = aws_vpc.this.default_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.this.id
# }

resource "aws_route_table" "eks_public_route_table" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }

    tags = {
        Name = "Public Subnet Route Table."
    }
}

resource "aws_subnet" "eks_public_subnets" {
 count = 3

 availability_zone       = data.aws_availability_zones.default.names[count.index]
 cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 100 + count.index)
 vpc_id                  = aws_vpc.this.id
 map_public_ip_on_launch = true

 tags = merge(
   {
     "Name" = "eks_public_subnet__${count.index}"
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
   }
 )
}

resource "aws_route_table_association" "eks_public_route_table_association" {
    count = 3
    subnet_id = aws_subnet.eks_public_subnets[count.index].id
    route_table_id = aws_route_table.eks_public_route_table.id
}









## PRIVATE SUBNETS

resource "aws_subnet" "eks_private_subnets" {
 count = 3

 availability_zone       = data.aws_availability_zones.default.names[count.index]
 cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 7, 100 + count.index)
 vpc_id                  = aws_vpc.this.id

 tags = merge(
   {
   "Name" = "eks_private_subnets__${count.index}"
   "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
   }
 )
}


resource "aws_route_table" "eks_private_route_table" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "Local Route Table for Isolated Private Subnet"
    }
}

resource "aws_route_table_association" "eks_private_route_table_association" {
    count = 3
    subnet_id = aws_subnet.eks_private_subnets[count.index].id
    route_table_id = aws_route_table.eks_private_route_table.id
}