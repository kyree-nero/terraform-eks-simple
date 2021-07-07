output "logging-firehose-name" {
    value = var.logging_type == "fluent-bit" ? aws_kinesis_firehose_delivery_stream.logging_s3_stream[0].name : "nothing to wait for"
}

