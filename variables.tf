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

variable "high_availability" {
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
    cidr = string
  }))

}

variable "private_subnets" {
  description = "A list of private subnet names"
  type = list(object({
    cidr = string
    type = string # e.g., "private" or "pod"
  }))

}

