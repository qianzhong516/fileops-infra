# 3 AZs, 3 public subnets, 3 private subnets

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(local.tags, {
    Name = "fileops-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(local.tags, {
    Name = each.key
  })
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(local.tags, {
    Name = each.key
  })
}

resource "aws_route_table" "public_route_table" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.main.id

  # Gateway Route
  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_subnet.public_subnet]

  tags = merge(local.tags, {
    Name = "${each.key}-route-table"
  })
}

resource "aws_route_table" "private_route_table" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.main.id

  depends_on = [aws_subnet.private_subnet]

  tags = merge(local.tags, {
    Name = "${each.key}-route-table"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_route_table.public_route_table

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = each.value.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_route_table.private_route_table

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = each.value.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "fileops-igw"
  })
}
