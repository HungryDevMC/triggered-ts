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

# Single consolidated security group for TeamSpeak
resource "aws_security_group" "teamspeak_sg" {
  name_prefix = "teamspeak-"
  vpc_id      = aws_default_vpc.triggered_vpc.id

  # TeamSpeak voice communication
  ingress {
    from_port   = 9987
    to_port     = 9987
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ServerQuery interface
  ingress {
    from_port   = 10011
    to_port     = 10011
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # File transfer
  ingress {
    from_port   = 30033
    to_port     = 30033
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "teamspeak-security-group"
  }
}