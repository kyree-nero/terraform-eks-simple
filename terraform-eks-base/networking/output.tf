

output "private_subnets" {
    value = aws_subnet.eks_public_subnets
}

output "public_subnets" {
    value = aws_subnet.eks_public_subnets
}

output "vpc_cidr_block" {
    value = aws_vpc.this.cidr_block
}

output "vpc_id" {
    value = aws_vpc.this.id
}


