
data "aws_ami" "centos_7" {
  most_recent      = true

  owners           = ["679593333241"]

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

  key_name = "${var.key_name}"
}

module "keypair" {
  source = "mitchellh/dynamic-keys/aws"
  name = "${var.key_name}"
  path   = "${path.root}/${var.key_path}"
}
