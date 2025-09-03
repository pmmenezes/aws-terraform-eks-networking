locals {
  # Pega as 3 primeiras Availability Zones disponíveis na região
  # Isso garante que as subnets serão distribuídas entre a, b e c
  # (ou as 3 primeiras que a AWS reportar como disponíveis).
  target_availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}