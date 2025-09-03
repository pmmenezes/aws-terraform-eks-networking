# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    var.vpc_tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}