# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "vpc" }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "internet-gateway" }
}

# Create subnets
resource "aws_subnet" "subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.counter
  cidr_block              = var.cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags                    = { Name = "SN-0${count.index + 1}" }
}

# Create the public table
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = { Name = "route-table" }
}

# Associate the route tables with the subnets
resource "aws_route_table_association" "route-table-association" {
  route_table_id = aws_route_table.route-table.id
  count          = var.counter
  subnet_id      = aws_subnet.subnets.*.id[count.index]
}

output "subnet-ids" {
  value = tolist(aws_subnet.subnets.*.id)
}

# Output the VPC
output "vpc" {
  value = aws_vpc.vpc
}

# Output the Internet gateway
output "internet-gateway" {
  value = aws_internet_gateway.internet-gateway
}

# Output the route table
output "route-table" {
  value = aws_route_table.route-table
}

# Output the route table association
output "route-table-association" {
  value = aws_route_table_association.route-table-association
}