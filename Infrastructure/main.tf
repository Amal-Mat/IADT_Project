/* # Generate Key-Pair which will be used for our instance

resource "tls_private_key" "ec2-key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}
   
output "key_ssh"{
    value = tls_private_key.ec2-key.public_key_openssh
}

output "pubkey"{
    value = tls_private_key.ec2-key.public_key_pem
}

# Creating private key

resource "local_file" "private_key" {
    depends_on      = [tls_private_key.ec2-key]
    content         = tls_private_key.ec2-key.private_key_pem
    filename        = "ec2-key.pem"
    file_permission = 0400
}

# Creating public key

resource "aws_key_pair" "webserver_key" {
    depends_on  = [local_file.private_key]
    key_name    = "ec2-key"
    public_key  = tls_private_key.ec2-key.public_key_openssh
}
 */
# Creating a VPC

resource "aws_vpc" "project-vpc" {
    cidr_block           = var.vpc-cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "project-vpc"
  }
}

# Internet Gateway for VPC

resource "aws_internet_gateway" "project-igw" {
    vpc_id = aws_vpc.project-vpc.id
}

# Create Public & Private Route Tables for VPC

resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.project-vpc.id
}

resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.project-vpc.id
}

# Route the public subnet traffic through the Internet Gateway

resource "aws_route" "public-internet-igw-route" {
    route_table_id         = aws_route_table.public-route-table.id
    gateway_id             = aws_internet_gateway.project-igw.id
    destination_cidr_block = "0.0.0.0/0"
}

# Public subnets

resource "aws_subnet" "public-subnet-1" {
    cidr_block        = var.public_subnet_1_cidr
    vpc_id            = aws_vpc.project-vpc.id
    availability_zone = var.availability_zones[0]
}

resource "aws_subnet" "public-subnet-2" {
    cidr_block        = var.public_subnet_2_cidr
    vpc_id            = aws_vpc.project-vpc.id
    availability_zone = var.availability_zones[1]
}

# Private subnets

resource "aws_subnet" "private-subnet-1" {
    cidr_block        = var.private_subnet_1_cidr
    vpc_id            = aws_vpc.project-vpc.id
    availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "private-subnet-2" {
    cidr_block        = var.private_subnet_2_cidr
    vpc_id            = aws_vpc.project-vpc.id
    availability_zone = var.availability_zones[1]
}

# Associate the newly created route tables to the subnets

resource "aws_route_table_association" "public-route-1-association" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-route-2-association" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "private-route-1-association" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-route-2-association" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id      = aws_subnet.private-subnet-2.id
}