output "cloud_custodian_offhours_role_arn" {
  value = aws_iam_role.cloud_custodian_offhours_role.arn
}

output "cloud_custodian_offhours_log_group_arn" {
  value = aws_cloudwatch_log_group.cloud_custodian_offhours.arn
}
