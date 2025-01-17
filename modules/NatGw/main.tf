resource "aws_eip" "nat-eip1" {
  domain = "vpc"

  tags = {
    Name = "NAT-GW-Eip1"
  }
}

resource "aws_eip" "nat-eip2" {
  domain = "vpc"

  tags = {
    Name = "NAT-GW-Eip2"
  }
}

resource "aws_nat_gateway" "ngw-pub-sub1" {
  subnet_id     = var.pub-sub1-id
  allocation_id = aws_eip.nat-eip1.id

  tags = {
    Name = "${var.project_name}-ngw-public-subnet-1"
  }

  depends_on = [var.igw_id]
}

resource "aws_nat_gateway" "ngw-pub-sub2" {
  subnet_id     = var.pub-sub2-id
  allocation_id = aws_eip.nat-eip2.id

  tags = {
    Name = "${var.project_name}-ngw-public-subnet-2"
  }

  depends_on = [var.igw_id]
}

resource "aws_route_table" "prv-rtb1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-pub-sub1.id
  }
  tags = {
    Name = "${var.project_name}-rtb-prv-sub1"
  }

}

resource "aws_route_table" "prv-rtb2" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-pub-sub2.id
  }

  tags = {
    Name = "${var.project_name}-rtb-prv-sub2"
  }

}

resource "aws_route_table_association" "rtb-assoc1" {
  subnet_id      = var.prv-sub1-id
  route_table_id = aws_route_table.prv-rtb1.id
}

resource "aws_route_table_association" "rtb-assoc2" {
  subnet_id      = var.prv-sub2-id
  route_table_id = aws_route_table.prv-rtb2.id

}
