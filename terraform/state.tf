data "aws_region" "current" {}

terraform {
  backend "s3" {
    bucket = "cloud-custodian-demo-test-terraform-state"
    key    = "cloud_custodian/demo.tfstate"
    region = "eu-west-1"

    dynamodb_table = "cloud-custodian-demo-test-terraform-state-lock"
    encrypt        = true
  }
}
