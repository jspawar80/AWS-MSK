variable "provider_region" {
  description = "The region where AWS resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Metadata to assign to the VPC"
  type        = map(string)
  default     = {
    Name = "Terraform VPC"
  }
}
