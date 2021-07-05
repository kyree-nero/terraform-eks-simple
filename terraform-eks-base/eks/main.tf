# EKS_CLUSTER_START
# ---------------------------------------------------------------------
#      Kubernetes AWS EKS cluster (Kubernetes control plane)
# ---------------------------------------------------------------------

# Uncomment to create AWS EKS cluster (Kubernetes control plane) - start
resource "aws_eks_cluster" "this" {
 name     = var.eks-cluster-name
 role_arn = var.eks-cluster-arn
 version  = var.kubernetes-version

 vpc_config {
   subnet_ids = var.private_subnets[*].id
 }

 # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
 # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.

  provisioner "local-exec" {
        command = "aws eks update-kubeconfig --kubeconfig ${path.cwd}/../k8s-${self.name}.yaml --name ${self.name}"
  }

  provisioner "local-exec" {
      when = destroy
      command = "rm -f ${path.cwd}/../k8s-${self.name}.yaml"
  }
}


# Uncomment to create AWS EKS cluster (Kubernetes control plane) - start
# EKS_CLUSTER_END






# EKS_NODE_GROUP_START
## ---------------------------------------------------------------------
##      Kubernetes AWS EKS node group (Kubernetes nodes)
## ---------------------------------------------------------------------

# Uncomment to create SSH key pair in AWS - start
resource "aws_key_pair" "this" {
 key_name   = "aws-eks-ssh-key"
 public_key = templatefile("${var.ssh_public_key_path}", {})
}
# Uncomment to create SSH key pair in AWS - end


# Uncomment to create AWS EKS cluster - node group - start
resource "aws_eks_node_group" "this" {
 cluster_name    = aws_eks_cluster.this.name
 node_group_name = "${var.eks-cluster-name}-node-group"
 node_role_arn = var.eks-cluster-node-group-arn

 subnet_ids = flatten([var.public_subnets[*].id, var.private_subnets[*].id])
 instance_types = [var.nodes_instance_type]
 tags           = var.custom_tags

 scaling_config {
   desired_size = var.desired_number_nodes
   max_size     = var.max_number_nodes
   min_size     = var.min_number_nodes
 }

 remote_access {
   ec2_ssh_key               = aws_key_pair.this.key_name
   source_security_group_ids = var.eks-worker-remote-source_security_group_ids
 }
  
  # launch_template {
  #   id      = aws_launch_template.eks-cluster-node-group-worker-nodes.id
  #   version = aws_launch_template.eks-cluster-node-group-worker-nodes.latest_version
  # }

#  launch_template {
#    name = aws_launch_template.eks_launch_template.name
#    version = aws_launch_template.eks_launch_template.latest_version
#   }
 # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
 # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
}
# Uncomment to create AWS EKS cluster (Kubernetes control plane) - end

# data "aws_ssm_parameter" "eks-worker-ami" {
#   name = "/aws/service/eks/optimized-ami/${var.kubernetes-version}/amazon-linux-2/recommended/image_id"
# }

# data "template_file" "userdata_spot_arm64" {
#   template = file("${path.module}/user-data.sh")
#   vars = {
#     cluster_name        = aws_eks_cluster.this.name
#     endpoint            = aws_eks_cluster.this.endpoint
#     cluster_auth_base64 = aws_eks_cluster.this.certificate_authority[0].data
#     node_lifecycle      = "spot"
#     node_taint          = "arch=NoSchedule"
#   }
# }

# resource "aws_launch_template" "eks-cluster-node-group-worker-nodes" {
#   image_id               = data.aws_ssm_parameter.eks-worker-ami.value
#   name                   = "${aws_eks_cluster.this.name}-eks-cluster-node-group-worker-nodes"
#   vpc_security_group_ids = var.eks-worker-remote-source_security_group_ids
#   user_data              = base64encode(data.template_file.userdata_spot_arm64.rendered)
#   ebs_optimized          = true

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 50
#       volume_type = "gp3"
#       iops        = 3000
#     }
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
#   depends_on = [aws_eks_cluster.this]
# }

	

/*
data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
}



resource "aws_launch_template" "eks_launch_template" {
  name = "eks_launch_template"
  key_name = aws_key_pair.this.key_name
  vpc_security_group_ids = flatten([var.eks-worker-remote-source_security_group_ids[*], aws_eks_cluster.this.vpc_config[0].cluster_security_group_id])

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  image_id =  data.aws_ami.server_ami.id
  instance_type = "t3.micro"
  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
/etc/eks/bootstrap.sh diu-eks-cluster
--==MYBOUNDARY==--\
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = var.custom_tags
  }

  depends_on = [
   aws_eks_cluster.this

 ]
}
*/
# Uncomment to create Security Group rule for Kubernetes SSH port 22, NodePort 30111 - start

resource "aws_security_group_rule" "this" {
 for_each = toset(var.tcp_ports)

 type              = "ingress"
 from_port         = each.value
 to_port           = each.value
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_eks_node_group.this.resources[0].remote_access_security_group_id

 depends_on = [
   aws_eks_node_group.this

 ]
}
## Uncomment to create Security Group rule for Kubernetes NodePort 30111 - start
# EKS_NODE_GROUP_END