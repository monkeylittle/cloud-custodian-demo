data "aws_iam_policy" "amazon_ec2_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "cloud_custodian_offhours_role" {
  name = "CloudCustodianRoleForOffHours"

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

resource "aws_iam_role_policy" "cloud_custodian_cloudwatch_logs_policy" {
  name = "CloudWatchLogsForCloudCustodian"
  role = "${aws_iam_role.cloud_custodian_offhours_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:DescribeLogGroups"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:log-group:/cloud_custodian/*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "cloud_custodian_offhours" {
  name = "/cloud_custodian/offhours"
}
