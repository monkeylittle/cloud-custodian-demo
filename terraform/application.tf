
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "centos_7" {
  most_recent = true

  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "web_server" {
  name_prefix = "web-server-"

  image_id      = "${data.aws_ami.centos_7.id}"
  instance_type = "t2.micro"

  key_name = "${module.ssh_key_pair.key_name}"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Customer    = "Acme Inc."
      Environment = "Production"
    }
  }
}

resource "aws_autoscaling_group" "web_server" {
  name = "Web Server ASG"

  availability_zones = "${data.aws_availability_zones.available.names}"

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  launch_template {
    id      = "${aws_launch_template.web_server.id}"
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Customer"
      value               = "Acme Inc."
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "Production"
      propagate_at_launch = true
    },
    {
      key                 = "AvailabilitySchedule"
      value               = "off=[(M-F,11)];on=[(M-F,9)];tz=bst"
      propagate_at_launch = false
    }
  ]
}

module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=tags/0.4.0"
  namespace             = "cloud-custodian-demo"
  stage                 = "test"
  name                  = "default"
  ssh_public_key_path   = ".secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}
