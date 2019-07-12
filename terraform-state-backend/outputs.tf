output "terraform_state_dynamodb_table_name" {
  value = "${module.terraform_state_backend.dynamodb_table_name}"
}

output "terraform_state_s3_bucket_id" {
  value = "${module.terraform_state_backend.s3_bucket_id}"
}
