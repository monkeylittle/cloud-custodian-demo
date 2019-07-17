data "aws_iam_policy" "amazon_ec2_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "cloud_custodian_role" {
  name = "CloudCustodianRole"

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

resource "aws_iam_role_policy_attachment" "cloud_custodian_role_policy_attachment" {
  role = "${aws_iam_role.cloud_custodian_role.name}"
  policy_arn = "${data.aws_iam_policy.amazon_ec2_full_access.arn}"
}

resource "aws_iam_role_policy" "cloud_custodian_cloudwatch_log_policy" {
  name = "CloudCustodianCloudWatchLogPolicy"
  role = "${aws_iam_role.cloud_custodian_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
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

resource "aws_iam_role_policy" "cloud_custodian_sqs_notification_policy" {
  name = "CloudCustodianSQSNotificationPolicy"
  role = "${aws_iam_role.cloud_custodian_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:ListAccountAliases"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage",
        "sqs:SendMessage"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sqs:eu-west-1:054250436230:cloud-custodian-mailer-queue"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "cloud_custodian_scheduled_availability" {
  name = "/cloud_custodian/scheduled_availability"
}

resource "aws_sqs_queue" "cloud_custodian_mailer_queue" {
  name                      = "cloud-custodian-mailer-queue"

  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}
