# Create private Subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "private" {
  for_each = { for idx, subnet in var.private_subnets : idx => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = element(local.target_availability_zones, each.key % length(local.target_availability_zones))
  map_public_ip_on_launch = false

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-${each.value.type}-subnet-${split("-", local.target_availability_zones[each.key % length(local.target_availability_zones)])[2]}"

    }
  )
  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

# Create private Route Table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "private" {
  for_each = var.high_availability ? { for idx, subnet in var.private_subnets : idx => subnet } : { 0 = var.private_subnets[0] }
  vpc_id   = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-private-rt-${split("-", local.target_availability_zones[each.key % length(local.target_availability_zones)])[2]}"
    }
  )

}

## Create Route to Nat Gateway in private Route Table
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "private_internet_access" {
  for_each               = aws_nat_gateway.main
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id

}

# Associate private Subnets with private Route Table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "private" {
  for_each       = { for idx, subnet in aws_subnet.private : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = var.high_availability ? aws_route_table.private[each.key].id : aws_route_table.private["0"].id
}