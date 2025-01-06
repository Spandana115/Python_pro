
resource "aws_vpc" "demovpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Web Subnet 1"
  }
}

resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
  tags = {
    Name = "Route to Internet"
  }
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "demosg" {
  vpc_id = aws_vpc.demovpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web SG"
  }
}

resource "aws_instance" "demoinstance" {
  ami                    = "ami-0166fe664262f664c"
  instance_type          = "t2.micro"
  key_name               = "spandana"
  vpc_security_group_ids = [aws_security_group.demosg.id]
  subnet_id              = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  user_data              = file("data.sh")
  tags = {
    Name = "My Public Instance"
  }
}

