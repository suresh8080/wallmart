variable "region" {
default="us-east-1"
}
variable "vpc-cidr" {
default="10.16.0.0/16"
}
variable "pub-sub" {
 type="list"
 default=["10.16.0.0/24","10.16.1.0/24"]
 }
variable "pvt-sub" {
 type="list"
 default=["10.16.2.0/24","10.16.3.0/24"]
 }
data "aws_availability_zones" "available" {}
#data "aws_nat_gateway" "igw"{}
