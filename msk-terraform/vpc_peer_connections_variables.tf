variable "peer_vpc_id" {
  description = "The ID of the VPC with which you are creating the VPC Peering Connection"
  type        = string
  default     = "vpc-c5b68abd"  # Replace with your actual VPC ID
}

variable "peer_connection_tags" {
  description = "Metadata to assign to the VPC Peering Connection"
  type        = map(string)
  default     = {
    Name = "VPC-Peering-Connection"
  }
}

variable "destination_cidr_block" {
  description = "The CIDR block for the VPC Peering Routes"
  type        = string
  default     = "172.31.0.0/16"
}
