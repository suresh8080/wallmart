provider "aws" {
 region="${var.region}"
 }
 resource "aws_vpc" "demo-vpc" {
  cidr_block="${var.vpc-cidr}"
  tags {
  Name="my-vpc"
  }
 }
 resource "aws_subnet" "public-subnet" {
 count="${length(var.pub-sub)}"
 vpc_id="${aws_vpc.demo-vpc.id}"
 cidr_block="${element(var.pub-sub,count.index)}"
 availability_zone="${element(data.aws_availability_zones.available.names,count.index)}"
 tags {
 Name="pub-sub-${count.index+1}"
 }
}
resource "aws_subnet" "pvt-subnet"{
 count="${length(var.pvt-sub)}"
 vpc_id="${aws_vpc.demo-vpc.id}"
 cidr_block="${element(var.pvt-sub,count.index)}"
 availability_zone="${element(data.aws_availability_zones.available.names,count.index)}"
 tags {
 Name="pvt-sub-${count.index+3}"
 }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.demo-vpc.id}"
  tags {
    Name = "my-igw"
  }
}
resource "aws_route_table" "pub-rt" {
  vpc_id = "${aws_vpc.demo-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
tags {
    Name = "pub-rt"
  }
}
resource "aws_eip" "eip" {
 # instance="${aws_instance.inst.id}"
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "ngw" {
 subnet_id="${element(aws_subnet.public-subnet.*.id,1)}"
 allocation_id="${aws_eip.eip.id}"
}
resource "aws_route_table" "pvt-rt" {
 vpc_id="${aws_vpc.demo-vpc.id}"
 route {
 cidr_block="0.0.0.0/0"
 nat_gateway_id="${aws_nat_gateway.ngw.id}"
 }
 tags {
   Name="pvt-rt"
}
}
resource "aws_route_table_association" "pub-asso"{
  count="${length(var.pub-sub)}"
  subnet_id="${element(aws_subnet.public-subnet.*.id,count.index)}"
  route_table_id="${aws_route_table.pub-rt.id}"
  }
resource "aws_route_table_association" "pvt-asso"{
  count="${length(var.pvt-sub)}"
  subnet_id="${element(aws_subnet.pvt-subnet.*.id,count.index)}"
  route_table_id="${aws_route_table.pvt-rt.id}"
  }

resource "aws_security_group" "sec-grp" {
  vpc_id      = "${aws_vpc.demo-vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
   }
   tags {
     Name="kranthi"
	 }
}


