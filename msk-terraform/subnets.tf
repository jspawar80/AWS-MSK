resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zones[0]
  tags              = var.public_subnet_tags[0]
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zones[1]
  tags              = var.public_subnet_tags[1]
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[2]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zones[2]
  tags              = var.public_subnet_tags[2]
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]
  tags              = var.private_subnet_tags[0]
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]
  tags              = var.private_subnet_tags[1]
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[2]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zones[2]
  tags              = var.private_subnet_tags[2]
}
