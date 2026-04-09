resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = data.aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
