resource "aws_default_vpc" "triggered_vpc" {
}

resource "aws_default_subnet" "triggered_subnet_a" {
  availability_zone = "eu-west-1a"
}

resource "aws_default_subnet" "triggered_subnet_b" {
  availability_zone = "eu-west-1b"
}

resource "aws_default_subnet" "triggered_subnet_c" {
  availability_zone = "eu-west-1c"
}

resource "aws_default_security_group" "triggered_security_group_9987" {
  vpc_id = aws_default_vpc.triggered_vpc.id

  ingress {
    protocol    = "udp"
    self        = true
    from_port   = 9987
    to_port     = 9987
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_default_security_group" "triggered_security_group_10011" {
  vpc_id = aws_default_vpc.triggered_vpc.id

  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 10011
    to_port     = 10011
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_default_security_group" "triggered_security_group_30033" {
  vpc_id = aws_default_vpc.triggered_vpc.id

  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 30033
    to_port     = 30033
    cidr_blocks = ["0.0.0.0/0"]
  }

}