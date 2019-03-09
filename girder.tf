### EC2 Girder ###
resource "aws_instance" "fungal_girder" {
  instance_type = "t3.medium"
  ami = "ami-05aa248bfb1c99d0f"
  key_name = "${aws_key_pair.fungal.key_name}"

  ebs_optimized = true
  credit_specification = {
    cpu_credits = "unlimited"
  }

  iam_instance_profile = "${aws_iam_instance_profile.fungal_girder.name}"

  instance_initiated_shutdown_behavior = "stop"
  monitoring = false

  vpc_security_group_ids = ["${aws_security_group.fungal_girder.id}"]
  subnet_id = "${data.aws_subnet.fungal.id}"

  root_block_device {
    volume_size = 40
    volume_type = "gp2"
  }

  tags {
    Name = "fungal-girder"
  }
}

resource "aws_key_pair" "fungal" {
  key_name   = "fungal-root"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbc8NJ2LEAbKagJkiSBp+W65LqlNxod8y+jr5Ai+7XfDtQXZOd2PyKl/hVeFQumFtrxFsFcKZ2VYCszh7D91CunHvAN+XKL9KNVMUzOoxgAH0GwHnVEMC6GwCDPtHCNctV3/8Hb2Q033r/B53xNAxXfYLsMg3w94VHs80fqcmwGZuqxfZc2jlvwdssjqhGx5jR4khiv5fD/FHQ9bpek8RerhY7sV0JGa+B3to+oxrJ++C8Y3ePZztt+EQ3XeSl8LscY2Eh10/kR+Qjm0v+ExtnzjYAMTY5gooCXc7zvVpYFth897pY1py8PjJ+gs8HwwQ3LhxArbba/+uC55DvXl8j fungal-root"
}

### Security group for EC2 Girder ###
resource "aws_security_group" "fungal_girder" {
  name        = "fungal-girder"
  vpc_id      = "${data.aws_vpc.fungal.id}"
}

resource "aws_security_group_rule" "fungal_girder_egress" {
  security_group_id = "${aws_security_group.fungal_girder.id}"
  type            = "egress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "fungal_girder_ingress_ssh" {
  security_group_id = "${aws_security_group.fungal_girder.id}"
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "fungal_girder_ingress_http" {
  security_group_id = "${aws_security_group.fungal_girder.id}"
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "fungal_girder_ingress_https" {
  security_group_id = "${aws_security_group.fungal_girder.id}"
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

### IAM Role for EC2 Girder ###
resource "aws_iam_role" "fungal_girder" {
  name = "fungal-girder"
  assume_role_policy = "${data.aws_iam_policy_document.fungal_girder_assumeRolePolicy.json}"
}

data "aws_iam_policy_document" "fungal_girder_assumeRolePolicy" {
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

resource "aws_iam_instance_profile" "fungal_girder" {
  name = "fungal-girder"
  role = "${aws_iam_role.fungal_girder.name}"
}

### DNS for EC2 Girder ###
resource "aws_eip" "fungal_girder" {
  instance = "${aws_instance.fungal_girder.id}"
  vpc = true

  tags {
    Name = "fungal-girder"
  }
}

resource "aws_route53_record" "fungal_girder" {
  zone_id = "${aws_route53_zone.fungal.zone_id}"
  name    = "data"
  type    = "A"
  ttl     = "300"
  records = [
    "${aws_eip.fungal_girder.public_ip}",
  ]
}

### MongoDB EBS volume for EC2 Girder ###
resource "aws_ebs_volume" "fungal_girder_mongodb" {
  availability_zone = "${aws_instance.fungal_girder.availability_zone}"
  type = "gp2"
  size = 50

  tags {
    Name = "fungal-girder-mongodb"
  }
}

resource "aws_volume_attachment" "fungal_girder_mongodb" {
  device_name = "/dev/sdf"
  volume_id   = "${aws_ebs_volume.fungal_girder_mongodb.id}"
  instance_id = "${aws_instance.fungal_girder.id}"
}

### S3 bucket for Girder assetstore ###
resource "aws_s3_bucket" "fungal_girder_assetstore" {
  bucket = "fungal-girder-assetstore"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["POST", "PUT"]
    allowed_origins = ["https://${aws_route53_record.fungal_girder.fqdn}"]
    expose_headers  = [
      # https://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html
      "Content-Length",
      "Connection",
      "Date",
      "ETag",
      "Server",
      "x-amz-delete-marker",
      "x-amz-version-id"
      # Exclude "x-amz-request-id" and "x-amz-id-2", as they are only for debugging
    ]
    max_age_seconds = 600
  }
}

resource "aws_iam_role_policy" "fungal_girder_assetstore" {
  name = "fungal-girder-assetstore"
  role = "${aws_iam_role.fungal_girder.id}"
  policy = "${data.aws_iam_policy_document.fungal_girder_assetstore.json}"
}

data "aws_iam_policy_document" "fungal_girder_assetstore" {
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.fungal_girder_assetstore.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.fungal_girder_assetstore.bucket}/*",
    ]
  }
}

### Outputs ###
output fungal_girder_fqdn {
  value = "${aws_route53_record.fungal_girder.fqdn}"
}
output "fungal_girder_ip" {
  value = "${aws_eip.fungal_girder.public_ip}"
}
output "fungal_girder_assetstore_bucket" {
  value = "${aws_s3_bucket.fungal_girder_assetstore.bucket}"
}
