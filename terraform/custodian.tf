data "aws_iam_policy" "amazon_ec2_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "cloud_custodian_offhours_role" {
  name = "cloud_custodian_offhours_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloud_custodian_offhours_role_policy_attachment" {
  role = "${aws_iam_role.cloud_custodian_offhours_role.name}"
  policy_arn = "${data.aws_iam_policy.amazon_ec2_full_access.arn}"
}
