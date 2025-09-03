# Create Public Subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public" {
  for_each = { for idx, subnet in var.public_subnets : idx => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = element(local.target_availability_zones, each.key % length(local.target_availability_zones))
  map_public_ip_on_launch = true

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-public-subnet-${split("-", local.target_availability_zones[each.key % length(local.target_availability_zones)])[2]}"
    }
  )
  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

# Create Public Route Table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-public-rt"
    }
  )

}
# Create Route to Internet Gateway in Public Route Table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  depends_on             = [aws_internet_gateway.main]
}

# Associate Public Subnets with Public Route Table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}