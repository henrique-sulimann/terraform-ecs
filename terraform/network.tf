data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "ECS VPC - ${local.app_name}"
    Env = var.env
  }
}

resource "aws_subnet" "private" {
  count = var.az_count
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block,8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.this.id
}
resource "aws_subnet" "public" {
  count = var.az_count
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block,8,var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.this.id
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}

resource "aws_eip" "this" {
  count = var.az_count
  vpc = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.az_count
  subnet_id = aws_subnet.public.*.id[count.index]
  allocation_id = aws_eip.this.*.id[count.index]
}

resource "aws_route_table" "private" {
  count = var.az_count
  vpc_id = aws_vpc.this.id

  route = [ {
    cidr_block = "0.0.0.0/0"
    egress_only_gateway_id = ""
    gateway_id = ""
    instance_id = ""
    ipv6_cidr_block = ""
    local_gateway_id = ""
    nat_gateway_id = aws_nat_gateway.this.*.id[count.index]
    network_interface_id = ""
    transit_gateway_id = ""
    vpc_endpoint_id = ""
    vpc_peering_connection_id = ""
  } ]
}

resource "aws_route_table_association" "private" {
  count = var.az_count
  subnet_id = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}