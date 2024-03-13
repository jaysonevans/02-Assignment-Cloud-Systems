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

# Create a public subnet using 192.168.0.0/18
resource "aws_subnet" "SUBNET-MARK-I" {
  vpc_id                  = aws_vpc.VPC-MARK-I.id
  cidr_block              = "192.168.0.0/18"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "SUBNET-MARK-I" }
}

# Create a public subnet using 192.168.64.0/18
resource "aws_subnet" "SUBNET-MARK-II" {
  vpc_id                  = aws_vpc.VPC-MARK-I.id
  cidr_block              = "192.168.64.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "SUBNET-MARK-II" }
}

# Create a public subnet using 192.168.128.0/18
resource "aws_subnet" "SUBNET-MARK-III" {
  vpc_id                  = aws_vpc.VPC-MARK-I.id
  cidr_block              = "192.168.128.0/18"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags                    = { Name = "SUBNET-MARK-III" }
}

# Create a public subnet using 192.168.192.0/18
resource "aws_subnet" "SUBNET-MARK-IV" {
  vpc_id                  = aws_vpc.VPC-MARK-I.id
  cidr_block              = "192.168.192.0/18"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true
  tags                    = { Name = "SUBNET-MARK-IV" }
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

# Associate the route tables with the subnet one
resource "aws_route_table_association" "ASSOCIATION-MARK-I" {
  route_table_id = aws_route_table.PUBLIC-RT-MARK-I.id
  subnet_id = aws_subnet.SUBNET-MARK-I.id
}

resource "aws_route_table_association" "ASSOCIATION-MARK-II" {
  route_table_id = aws_route_table.PUBLIC-RT-MARK-I.id
  subnet_id = aws_subnet.SUBNET-MARK-II.id
}

resource "aws_route_table_association" "ASSOCIATION-MARK-III" {
  route_table_id = aws_route_table.PUBLIC-RT-MARK-I.id
  subnet_id = aws_subnet.SUBNET-MARK-III.id
}

resource "aws_route_table_association" "ASSOCIATION-MARK-IV" {
  route_table_id = aws_route_table.PUBLIC-RT-MARK-I.id
  subnet_id = aws_subnet.SUBNET-MARK-IV.id
}

# Filter for all subnets in the VPC
data "aws_subnets" "ALL-SUBNETS" {
  filter {
    name = "VPC-MARK-I"
    values = [aws_vpc.VPC-MARK-I.id]
  }
}

# Output the list of subnets in the VPC
output "ALL-SUBNET-IDS" {
  value = tolist(data.aws_subnets.ALL-SUBNETS.ids)
}

# Output the VPCterr
output "VPC-MARK-I" {
  value = aws_vpc.VPC-MARK-I
}