output "cloud_custodian_role_arn" {
  value = aws_iam_role.cloud_custodian_role.arn
}

output "cloud_custodian_mailer_queue_url" {
  value = aws_sqs_queue.cloud_custodian_mailer_queue.id
}
