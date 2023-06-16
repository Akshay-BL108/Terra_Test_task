variable "aws_availability_zones" {
  type = list(string)
}
variable "public_cidrs" {
  type = list(string)
}
variable "privet_cidrs" {
  type = list(string)
}
variable "no_of_public_ec2_ins" {
  type = number
}
variable "ami_id" {
}
variable "instance_type" {
}

variable "db_instance" {
}
# variable "subnet2" {
# }