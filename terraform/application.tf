
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

resource "aws_instance" "web_server" {
  ami           = "${data.aws_ami.centos_7.id}"
  instance_type = "t2.micro"

  key_name = "${module.ssh_key_pair.key_name}"

  tags = {
    Customer    = "Acme Inc."
    Environment = "Production"

    AvailabilitySchedule = "off=[(M-F,12)];on=[(M-F,9)];tz=bst"
  }
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
