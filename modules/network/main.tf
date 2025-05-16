data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# VPC

resource "aws_vpc" "this" {
  cidr_block          = var.cidr

  enable_dns_hostnames                 = true
  enable_dns_support                   = true
}

# Public Subnets

resource "aws_subnet" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block                                     = element(concat(var.public_subnets, [""]), count.index)
  vpc_id                                         = aws_vpc.this.id
  tags = var.public_subnet_tags
}

resource "aws_route_table" "public" {
  count = local.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_internet_gateway" {
  count = local.create_public_subnets ? 1 : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

# Private Subnets

resource "aws_subnet" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block                                     = element(concat(var.private_subnets, [""]), count.index)
  vpc_id                                         = aws_vpc.this.id
  tags = var.private_subnet_tags
}

resource "aws_route_table" "private" {
  count = local.create_private_subnets ? local.nat_gateway_count : 0

  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    count.index,
  )
}

# Database Subnets

resource "aws_subnet" "database" {
  count = local.create_database_subnets ? local.len_database_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block                                     = element(concat(var.database_subnets, [""]), count.index)
  vpc_id                                         = aws_vpc.this.id
  tags = var.database_subnets_tags
}

resource "aws_db_subnet_group" "database" {
  count = local.create_database_subnets ? 1 : 0

  name        = var.name
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database[*].id
}

resource "aws_route_table_association" "database" {
  count = local.create_database_subnets ? local.len_database_subnets : 0

  subnet_id = element(aws_subnet.database[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    count.index,
  )
}

# Internet Gateway

resource "aws_internet_gateway" "this" {
  count = local.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.this.id
}

# NAT Gateway

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  domain = "vpc"
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    aws_eip.nat[*].id,
    count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    count.index,
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}
