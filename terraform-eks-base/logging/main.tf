

# needed for fluentd
resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-CloudWatchLogsFullAccess" {
 count = var.logging_type == "fluentd" ? 1 : 0
 policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
 role       = var.eks_cluster_node_group_name
}


# needed for fluentbit

resource "aws_s3_bucket" "kube_logs_bucket" {
  count = var.logging_type == "fluent-bit" ? 1 : 0
  bucket_prefix = "kube-logs" 
  force_destroy = true
  acl = "private"
  versioning {
        enabled = true
    }
}


resource "aws_iam_policy" "eks_fluent_bit_daemonset_policy" {
  count = var.logging_type == "fluent-bit" ? 1 : 0
  name        = "eks_fluent_bit_daemonset_policy"
  path        = "/"
  description = "TBD"

  policy = file("logging/fluentbit-daemonset-policy.json")  

}


resource "aws_iam_role_policy_attachment" "diu-eks-cluster-node-group-EKSFluentBitDaemonSetPolicy" {
 count = var.logging_type == "fluent-bit" ? 1 : 0
 policy_arn = aws_iam_policy.eks_fluent_bit_daemonset_policy[0].arn
 role       = var.eks_cluster_node_group_name
}

resource "aws_iam_policy" "eks_fluent_bit_firehose_policy" {
  count = var.logging_type == "fluent-bit" ? 1 : 0
  name        = "eks_fluent_bit_firehose_policy"
  path        = "/"
  description = "TBD"

  policy = templatefile(
    "logging/fluentbit-firehose-delivery-policy.json", 
    {
      aws_account_number = var.aws_account_number, 
      aws_region = var.aws_region
      logs_bucket_name = aws_s3_bucket.kube_logs_bucket[0].bucket
    }
  )  

}

resource "aws_iam_role" "eks_fluent_bit_firehose_role" {
  count = var.logging_type == "fluent-bit" ? 1 : 0
 name = "diu-EksClusterLoggingFirefoseRole-tf"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
  }
}

POLICY
}

resource "aws_iam_role_policy_attachment" "loggingFireHose-EKSFluentBitFirehosePolicy" {
 count = var.logging_type == "fluent-bit" ? 1 : 0
 policy_arn = aws_iam_policy.eks_fluent_bit_firehose_policy[0].arn
 role       = aws_iam_role.eks_fluent_bit_firehose_role[0].name
}

resource "aws_kinesis_firehose_delivery_stream" "logging_s3_stream" {
  count = var.logging_type == "fluent-bit" ? 1 : 0
  name        = "eks-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.eks_fluent_bit_firehose_role[0].arn
    bucket_arn = aws_s3_bucket.kube_logs_bucket[0].arn
  }

  
}
