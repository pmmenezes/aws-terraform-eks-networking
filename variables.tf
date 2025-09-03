## Common Variables 
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "region" {
  description = "value for region"
  type        = string
  default     = "us-east-1"
}

variable "default_tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "one_nat_gateway_per_az" {
  description = "Enable high availability for NAT gateways"
  type        = bool
  default     = false
}
## VPC Variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_additional_cidrs" {
  description = "Additional CIDR blocks for the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "A map of tags to assign to the VPC"
  type        = map(string)
  default     = {}
}
## Subnets Variables
variable "public_subnets" {
  description = "A list of public subnet names"
  type = list(object({
    cidr        = string
    prefix_name = string # e.g., "public" or "ingress"
  }))

}

variable "private_subnets" {
  description = "A list of private subnet names"
  type = list(object({
    cidr        = string
    prefix_name = string # e.g., "private" or "pod"
  }))

}

variable "database_subnets" {
  description = "A list of private subnet names"
  type = list(object({
    cidr        = string
    prefix_name = string # e.g., "private" or "pod"
  }))
  default = []

}


variable "database_nacl_network_rules" {
  description = "List of network ACL rules for the database subnets"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    egress      = optional(bool)
    cidr_block  = string
    from_port   = number
    to_port     = number

  }))
  default = {}
}

variable "private_nacl_network_rules" {
  description = "List of network ACL rules for the database subnets"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    egress      = optional(bool)
    cidr_block  = string
    from_port   = number
    to_port     = number

  }))
  default = {}
}

variable "public_nacl_network_rules" {
  description = "List of network ACL rules for the database subnets"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
    egress      = optional(bool)

  }))
  default = {}
}

