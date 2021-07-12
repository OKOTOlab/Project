provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "EC2-new" {
  ami = "ami-00f22f6155d6d92c5"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_security.id]
  key_name = "Test key pair"
  tags = {
    Name = "EC2-Terraform"
  }
  user_data = <<-EOF
                    #!/bin/bash
                    sudo yum install ec2-instance-connect
                    sudo yum update -y
                     sudo amazon-linux-extras install nginx1 -y
                    sudo service nginx start
                EOF
}


resource "aws_security_group" "web_security" {
  name = "web-security"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terralab2021071208165443720000024201"
  acl    = "private"
  tags = {
    Name        = "My bucket"
    Environment = "Test"
  }

  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true
    expiration {
      days = 30
    }

  }
}

resource "aws_s3_bucket_object" "upload_file" {
  bucket = "terralab2021071208165443720000024201"
  key = "website.html"
  content_type = "text/html"
  source = "G:/Project/website.html"
  acl = "private"
  depends_on = [aws_s3_bucket.bucket]
}

