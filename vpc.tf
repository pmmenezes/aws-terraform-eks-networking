# Create VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  tags                 = merge(var.vpc_tags, { Name = "${var.project_name}-vpc" })
}
# Associate Additional CIDR Blocks
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association
resource "aws_vpc_ipv4_cidr_block_association" "main" {
  for_each   = toset(var.vpc_additional_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  depends_on = [aws_vpc.main]
}

resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  #ingress {
  #  protocol   = -1
  #  rule_no    = 100
  #  action     = "allow"
  #  cidr_block = aws_vpc.main.cidr_block
  #  from_port  = 0
  #  to_port    = 0
  #}
  #
  #egress {
  #  protocol   = -1
  #  rule_no    = 100
  #  action     = "allow"
  #  cidr_block = "0.0.0.0/0"
  #  from_port  = 0
  #  to_port    = 0
  #}

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-default-nacl"
    }
  )
}
