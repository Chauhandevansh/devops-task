output "vpc_id" {
  value = aws_vpc.Swayatt-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "igw_id" {
  value = aws_internet_gateway.simple-igw.id
}

