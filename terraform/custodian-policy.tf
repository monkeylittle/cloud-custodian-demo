data "template_file" "cloud_custodian_aws_asg_scheduled_availability" {
  template = "${file("template/cloud-custodian/policy/aws-asg-scheduled-availability.tpl")}"

  vars = {
    cloud_custodian_role_arn = "${ aws_iam_role.cloud_custodian_role.arn }"
    cloud_custodian_mailer_queue_url = "${ aws_sqs_queue.cloud_custodian_mailer_queue.id }"

    cloud_custodian_mailer_slack_hook_url = "${ var.cloud_custodian_mailer_slack_hook_url }"
  }
}

resource "local_file" "cloud_custodian_asg_scheduled_availability_policy" {
    content     = "${ data.template_file.cloud_custodian_aws_asg_scheduled_availability.rendered }"
    filename = "../custodian-aws-asg-scheduled-availability-policy.yml"
}

data "template_file" "cloud_custodian_aws_ec2_scheduled_availability" {
  template = "${file("template/cloud-custodian/policy/aws-ec2-scheduled-availability.tpl")}"

  vars = {
    cloud_custodian_role_arn = "${ aws_iam_role.cloud_custodian_role.arn }"
    cloud_custodian_mailer_queue_url = "${ aws_sqs_queue.cloud_custodian_mailer_queue.id }"

    cloud_custodian_mailer_slack_hook_url = "${ var.cloud_custodian_mailer_slack_hook_url }"
  }
}

resource "local_file" "cloud_custodian_ec2_scheduled_availability_policy" {
    content     = "${ data.template_file.cloud_custodian_aws_ec2_scheduled_availability.rendered }"
    filename = "../custodian-aws-ec2-scheduled-availability-policy.yml"
}

data "template_file" "cloud_custodian_slack_notification" {
  template = "${file("template/cloud-custodian/policy/aws-slack-notification.tpl")}"
  vars = {
    cloud_custodian_mailer_queue_url: "${ aws_sqs_queue.cloud_custodian_mailer_queue.id }"
    cloud_custodian_mailer_role_arn: "${ aws_iam_role.cloud_custodian_role.arn }"
    cloud_custodian_mailer_region: "${ data.aws_region.current.name }"
  }
}

resource "local_file" "cloud_custodian_slack_notification_policy" {
    content     = "${ data.template_file.cloud_custodian_slack_notification.rendered }"
    filename = "../custodian-aws-slack-notification-policy.yml"
}
