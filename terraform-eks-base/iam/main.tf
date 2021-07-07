resource "aws_iam_role" "diu-eks-cluster" {
 name = "diu-EksClusterIAMRole-tf"

 assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Service": "eks.amazonaws.com"
     },
     "Action": "sts:AssumeRole"
   }
 ]
}

POLICY
}

resource "aws_iam_role_policy_attachment" "diu-eks-cluster-AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role       = aws_iam_role.diu-eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "diu-eks-cluster-AmazonEKSServicePolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
 role       = aws_iam_role.diu-eks-cluster.name
}

# IAM AWS role for Node Group
resource "aws_iam_role" "diu-eks-cluster-node-group" {
 name = "diu-EksClusterNodeGroup-tf"

 assume_role_policy = jsonencode({
   Statement = [{
     Action = "sts:AssumeRole"
     Effect = "Allow"
     Principal = {
       Service = "ec2.amazonaws.com"
     }
   }]
   Version = "2012-10-17"
 })
}

resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-AmazonEKSWorkerNodePolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
 role       = aws_iam_role.diu-eks-cluster-node-group.name
}

resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-AmazonEKS_CNI_Policy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
 role       = aws_iam_role.diu-eks-cluster-node-group.name
}

resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-AmazonEC2ContainerRegistryReadOnly" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role       = aws_iam_role.diu-eks-cluster-node-group.name
}

# # needed for fluentd
# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-CloudWatchLogsFullAccess" {
#  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
#  role       = aws_iam_role.diu-eks-cluster-node-group.name
# }


# # needed for fluentbit
# resource "aws_iam_policy" "eks_fluent_bit_daemonset_policy" {
#   name        = "eks_fluent_bit_daemonset_policy"
#   path        = "/"
#   description = "TBD"

#   policy = file("iam/fluentbit-daemonset-policy.json")  

# }

# # resource "aws_iam_policy" "eks_fluent_bit_daemonset_policy" {
# #   name        = "eks_fluent_bit_daemonset_policy"
# #   path        = "/"
# #   description = "TBD"

# #   policy = jsonencode(
# # {
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Effect": "Allow",
# #             "Action": [
# #                 "firehose:PutRecordBatch"
# #             ],
# #             "Resource": "*"
# #         },
# #         {
# #             "Effect": "Allow",
# #             "Action": "logs:PutLogEvents",
# #             "Resource": "arn:aws:logs:*:*:log-group:*:*:*"
# #         },
# #         {
# #             "Effect": "Allow",
# #             "Action": [
# #                 "logs:CreateLogStream",
# #                 "logs:DescribeLogStreams",
# #                 "logs:PutLogEvents"
# #             ],
# #             "Resource": "arn:aws:logs:*:*:log-group:*"
# #         },
# #         {
# #             "Effect": "Allow",
# #             "Action": "logs:CreateLogGroup",
# #             "Resource": "*"
# #         }
# #     ]
# # }
# #   )
# # }

# resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-EKSFluentBitDaemonSetPolicy" {
#  policy_arn = aws_iam_policy.eks_fluent_bit_daemonset_policy.arn
#  role       = aws_iam_role.diu-eks-cluster-node-group.name
# }


# resource "aws_iam_policy" "eks_fluent_bit_firehose_policy" {
#   name        = "eks_fluent_bit_firehose_policy"
#   path        = "/"
#   description = "TBD"

#   policy = templatefile(
#     "iam/fluentbit-firehose-delivery-policy.json", 
#     {
#       aws_account_number = var.aws_account_number, 
#       aws_region = var.aws_region
#       logs_bucket_name = var.logs_bucket_name
#     }
#   )  

# }

# resource "aws_iam_role" "eks_fluent_bit_firehose_role" {
#  name = "diu-EksClusterLoggingFirefoseRole-tf"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "firehose.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#   }
# }

# POLICY
# }

# resource "aws_iam_role_policy_attachment" "loggingFireHose-EKSFluentBitFirehosePolicy" {
#  policy_arn = aws_iam_policy.eks_fluent_bit_firehose_policy.arn
#  role       = aws_iam_role.eks_fluent_bit_firehose_role.name
# }

