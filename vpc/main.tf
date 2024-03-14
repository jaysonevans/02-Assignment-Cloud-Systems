# Create the VPC
resource "aws_vpc" "VPC-MARK-I" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "VPC-MARK-I" }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "GATEWAY-MARK-I" {
  vpc_id = aws_vpc.VPC-MARK-I.id
  tags   = { Name = "GATEWAY-MARK-I" }
}

# Create subnets
resource "aws_subnet" "SUBNETS" {
  vpc_id                  = aws_vpc.VPC-MARK-I.id
  count = var.counter
  cidr_block              = var.cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags                    = { Name = "SN-0${count.index + 1}" }
}

# Create the public table
resource "aws_route_table" "PUBLIC-RT-MARK-I" {
  vpc_id = aws_vpc.VPC-MARK-I.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GATEWAY-MARK-I.id
  }

  tags = { Name = "PUBLIC-RT-MARK-I" }
}

# Associate the route tables with the subnets
resource "aws_route_table_association" "ASSOCIATION-MARK-I" {
  route_table_id = aws_route_table.PUBLIC-RT-MARK-I.id
  count = var.counter
  subnet_id = aws_subnet.SUBNETS.*.id[count.index]
}

# Filter for all subnets in the VPC
data "aws_subnets" "subnets-in-vpc" {
  filter {
    name = "VPC-MARK-I"
    values = [aws_vpc.VPC-MARK-I.id]
  }
}

# Output the list of subnets in the VPC
output "subnets-in-vpc-ids" {
  value = tolist(data.aws_subnets.subnets-in-vpc.ids)
}

# Output the VPC
output "VPC-MARK-I" {
  value = aws_vpc.VPC-MARK-I
}