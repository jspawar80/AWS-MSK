resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = var.peer_vpc_id
  vpc_id      = aws_vpc.main.id
  auto_accept = true
  tags        = var.peer_connection_tags
}

# Public route table
resource "aws_route" "peer_route_public" {
  route_table_id             = aws_route_table.public.id
  destination_cidr_block     = var.destination_cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
}

# Private route table 1
resource "aws_route" "peer_route_private" {
  route_table_id             = aws_route_table.private.id
  destination_cidr_block     = var.destination_cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
}

# Private route table 2
resource "aws_route" "peer_route_private1" {
  route_table_id             = aws_route_table.private1.id
  destination_cidr_block     = var.destination_cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
}

# Private route table 3
resource "aws_route" "peer_route_private3" {
  route_table_id             = aws_route_table.private3.id
  destination_cidr_block     = var.destination_cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
}
