variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "map_public_ip_on_launch" {
  description = "Flag to enable/disable auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  description = "Metadata to assign to the public subnets"
  type        = list(map(string))
  default     = [
    { Name = "public_subnet_1" },
    { Name = "public_subnet_2" },
    { Name = "public_subnet_3" }
  ]
}

variable "private_subnet_tags" {
  description = "Metadata to assign to the private subnets"
  type        = list(map(string))
  default     = [
    { Name = "private_subnet_1" },
    { Name = "private_subnet_2" },
    { Name = "private_subnet_3" }
  ]
}
