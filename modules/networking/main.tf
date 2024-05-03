resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

  tags={
    "Name" = "${var.name}-vpc-k"
  }
}
resource "aws_subnet" "public_subnets" {
 for_each = toset(var.public_cidrs)
 vpc_id = aws_vpc.vpc.id
 cidr_block = each.key
 tags={
    "Name"="${var.name}-public-subnet-k-${each.key}"
 }
}
resource "aws_internet_gateway" "igw" {
  count = var.public_cidrs != [] ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}


resource "aws_route_table" "public" {
     count = var.public_cidrs != [] ? 1 : 0
  vpc_id = aws_vpc.vpc.id  
  
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }
}

resource "aws_route_table_association" "public" {
    for_each = toset(var.public_cidrs)
    route_table_id = aws_route_table.public[0].id
    subnet_id = aws_subnet.public_subnets[each.key].id
  
}
resource "aws_subnet" "private_subnets" {
 for_each = toset(var.private_cidrs)
 vpc_id = aws_vpc.vpc.id
 cidr_block = each.key
 tags={
    "Name"="${var.name}-private-subnet-k-${each.key}"
 }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element([for subnet in aws_subnet.public_subnets : subnet.id], 0) 
  tags = {
    "Name" = "${var.name}-nat-subnet"
  }
}

resource "aws_eip" "eip" {
   domain = "vpc"
  tags = {
   "Name" = "eip_for_nat"
   "Name" = var.name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id  
  
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id

  }
}

resource "aws_route_table_association" "private" {
    for_each = toset(var.private_cidrs)
    route_table_id = aws_route_table.private.id
    subnet_id = aws_subnet.private_subnets[each.key].id
  
}