# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "this" {
  for_each = var.high_availability ? { for idx, subnet in var.public_subnets : idx => subnet } : { 0 = var.public_subnets[0] }
  domain   = "vpc"
  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-nat-eip-${split("-", local.target_availability_zones[each.key % length(local.target_availability_zones)])[2]}"
    }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "main" {
  for_each          = var.high_availability ? { for idx, subnet in var.public_subnets : idx => subnet } : { 0 = var.public_subnets[0] }
  allocation_id     = aws_eip.this[each.key].id
  subnet_id         = aws_subnet.public[each.key].id
  connectivity_type = "public"
  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-nat-gw-${split("-", local.target_availability_zones[each.key % length(local.target_availability_zones)])[2]}"
    }
  )
  depends_on = [aws_internet_gateway.main]
}

