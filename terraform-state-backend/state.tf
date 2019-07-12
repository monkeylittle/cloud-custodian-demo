data "aws_region" "current" {}

module "terraform_state_backend" {
  source     = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.9.0"
  namespace  = "cloud-custodian-demo"
  stage      = "test"
  name       = "terraform"
  attributes = ["state"]
  region     = "${data.aws_region.current.name}"
}
