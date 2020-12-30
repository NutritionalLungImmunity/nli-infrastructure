resource "aws_instance" "worker" {
  instance_type = "t3.medium"
  ami           = "ami-0885b1f6bd170450c" # Ubuntu 20.04 LTS
  monitoring    = false

  vpc_security_group_ids = [aws_security_group.worker.id]
  iam_instance_profile   = aws_iam_instance_profile.worker.name
  key_name               = aws_key_pair.worker.key_name

  root_block_device {
    volume_size = 16
    volume_type = "gp2"
  }

  tags = {
    Name = "worker"
  }
}

data "aws_iam_policy_document" "worker_assumeRolePolicy" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "worker" {
  name               = "worker"
  assume_role_policy = data.aws_iam_policy_document.worker_assumeRolePolicy.json
}

resource "aws_iam_instance_profile" "worker" {
  name = "worker"
  role = aws_iam_role.worker.name
}

resource "aws_key_pair" "worker" {
  key_name   = "worker"
  public_key = data.local_file.ssh_public_key.content
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "worker" {
  name   = "worker"
  vpc_id = aws_default_vpc.default.id

  egress {
    description = "Any TCP"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "DNS queries"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "worker" {
  instance = aws_instance.worker.id

  tags = {
    Name = "worker"
  }
}
