# VPC 
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_availability_zones" "available" {
}


# Public Subnets
resource "aws_subnet" "public" {
  count = var.aws_subnets_count

  vpc_id = aws_vpc.main.id
  cidr_block        = "10.10.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id           = aws_vpc.main.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = var.aws_subnets_count

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# Private Subnets
resource "aws_subnet" "private" {
  count = var.aws_subnets_count

  vpc_id = aws_vpc.main.id
  cidr_block        = "10.10.${count.index + 128}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_route_table" "private" {
  vpc_id           = aws_vpc.main.id
  count            = var.aws_subnets_count
}

resource "aws_route_table_association" "private" {
  count          = var.aws_subnets_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


# NAT Gateways 
resource "aws_eip" "nateip" {
  count = var.aws_subnets_count

  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  count = var.aws_subnets_count

  allocation_id = element(aws_eip.nateip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private_nat_gateway" {
  count = var.aws_subnets_count 

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)
}
