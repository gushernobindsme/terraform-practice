# VPC
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

# パブリックサブネット
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
}

# プライベートサブネット
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

# EIP
resource "aws_eip" "nat_gateway_1a" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1c" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

# NAT ゲートウェイ
resource "aws_nat_gateway" "example_1a" {
  allocation_id = aws_eip.nat_gateway_1a.id
  subnet_id     = aws_subnet.public_1a.id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "example_1c" {
  allocation_id = aws_eip.nat_gateway_1c.id
  subnet_id     = aws_subnet.public_1c.id
  depends_on    = [aws_internet_gateway.example]
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.example.id
}

# ルート
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1a" {
  route_table_id         = aws_route_table.private_1a.id
  gateway_id             = aws_nat_gateway.example_1a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1c" {
  route_table_id         = aws_route_table.private_1c.id
  gateway_id             = aws_nat_gateway.example_1c.id
  destination_cidr_block = "0.0.0.0/0"
}

# ルートテーブルの関連付け
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}
