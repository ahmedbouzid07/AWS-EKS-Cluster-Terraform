resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "main-pub-sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub1_cidr_block
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.project_name}-public-subnet-1"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_subnet" "main-pub-sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub2_cidr_block
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.project_name}-public-subnet-2"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_subnet" "main-prv-sub1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.prv_sub1_cidr_block
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name                                        = "${var.project_name}-private-subnet-1"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_subnet" "main-prv-sub2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.prv_sub2_cidr_block
  availability_zone = data.aws_availability_zones.azs.names[1]


  tags = {
    Name                                        = "${var.project_name}-private-subnet-2"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_route_table" "main-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "${var.project_name}-rtb"
  }

}

resource "aws_route_table_association" "rtb-assoc-pub-sub1" {
  subnet_id      = aws_subnet.main-pub-sub1.id
  route_table_id = aws_route_table.main-rtb.id
}
resource "aws_route_table_association" "rtb-assoc-pub-sub2" {
  subnet_id      = aws_subnet.main-pub-sub2.id
  route_table_id = aws_route_table.main-rtb.id
}
