variable "sg_name" {
  description = "The name for the security group"
  type        = string
  default     = "allow_all"
}

variable "sg_description" {
  description = "The description for the security group"
  type        = string
  default     = "Allow all inbound traffic"
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "ingress_from_port" {
  description = "The starting range for the ingress rule"
  type        = number
  default     = 0
}

variable "ingress_to_port" {
  description = "The ending range for the ingress rule"
  type        = number
  default     = 0
}

variable "ingress_protocol" {
  description = "The protocol for the ingress rule"
  type        = string
  default     = "-1"
}

variable "ingress_cidr_blocks" {
  description = "The CIDR blocks for the ingress rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  description = "The starting range for the egress rule"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "The ending range for the egress rule"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "The protocol for the egress rule"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "The CIDR blocks for the egress rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
