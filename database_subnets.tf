# Create private Subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "database" {
  for_each = { for idx, subnet in var.database_subnets : idx => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = element(local.target_availability_zones, each.key % length(local.target_availability_zones))
  map_public_ip_on_launch = false

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-${each.value.prefix_name}-subnet-${split("-", local.target_availability_zones[each.key % length(local.target_availability_zones)])[2]}"
    }
  )
  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-database-nacl"
  })

}
resource "aws_network_acl_rule" "database_inbound" {

  for_each       = var.database_nacl_network_rules
  network_acl_id = aws_network_acl.database.id
  rule_number    = each.value.rule_number
  egress         = each.value.egress != null ? each.value.egress : false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block == null ? aws_vpc.main.cidr_block : each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port


}

resource "aws_network_acl_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.database.id

}


