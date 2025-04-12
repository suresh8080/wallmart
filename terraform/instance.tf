resource "aws_instance" "inst" {
   ami="ami-009d6802948d06e52"
   instance_type="t2.micro"
   key_name="${aws_key_pair.key.id}"
   associate_public_ip_address =true 
   count="${length(var.pub-sub)}"
   subnet_id="${element(aws_subnet.public-subnet.*.id,count.index)}"
   security_groups = ["${aws_security_group.sec-grp.id}"]
tags{
     Name="pub-ser-${count.index+1}"
    } 
  }
resource "aws_key_pair" "key" {
  key_name="devops"
  public_key="${file("devops.pub")}"
 } 
resource "aws_ebs_volume" "volume" {
  size= 10
  availability_zone="${element(data.aws_availability_zones.available.names,count.index)}"
  tags {
    Name = "volume"
  }
}

