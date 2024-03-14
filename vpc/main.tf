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

output "subnet-ids" {
  value = tolist(aws_subnet.SUBNETS.*.id)
}

# Output the VPC
output "VPC-MARK-I" {
  value = aws_vpc.VPC-MARK-I
}