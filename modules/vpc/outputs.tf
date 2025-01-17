output "vpc_id" {
    value = aws_vpc.main.id
}

output "pub-sub1-id" {
    value = aws_subnet.main-pub-sub1.id
}

output "pub-sub2-id" {
    value = aws_subnet.main-pub-sub2.id
}

output "prv-sub1-id" {
    value = aws_subnet.main-prv-sub1.id
}

output "prv-sub2-id" {
    value = aws_subnet.main-prv-sub1.id 
}

output "igw_id" {
    value = aws_internet_gateway.main-igw.id
}