resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.igw_tags
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.for_nat_gw.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags          = var.nat_tags
}

resource "aws_eip" "for_nat_gw" {}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.public_route_table_tags
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.route_table_cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = var.private_route_table_tags[0]
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.route_table_cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = var.private_route_table_tags[1]
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table" "private3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.route_table_cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = var.private_route_table_tags[2]
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private3.id
}
