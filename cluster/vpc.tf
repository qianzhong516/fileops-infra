# 3 AZs, 3 public subnets, 3 private subnets

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.tags, {
    Name = "fileops-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_route_table" "public_route_table" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_subnet.public_subnet]

  tags = merge(var.tags, {
    Name = "${each.key}-route-table"
  })
}

resource "aws_route_table" "private_route_table" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  depends_on = [aws_subnet.private_subnet]

  tags = merge(var.tags, {
    Name = "${each.key}-route-table"
  })
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_route_table[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "fileops-igw"
  })
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  # TODO: set this for DEV only
  availability_mode = "regional"
  # Required when `availability_mode` is set to `regional`
  vpc_id = aws_vpc.main.id

  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.tags, {
    Name = "fileops-nat"
  })
}
