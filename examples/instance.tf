data "aws_ami" "aws_linux" {
  owners      = ["898082745236"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Deep Learning AMI GPU PyTorch 1.13.1 (Amazon Linux 2) *"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

## key pair
resource "aws_key_pair" "tera-key" {
  key_name   = "tera-key"
  public_key = file("${path.module}/id_rsa.pub")

}

resource "aws_instance" "web1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.no_of_public_ec2_ins
  key_name               = aws_key_pair.tera-key.key_name
  vpc_security_group_ids = ["${aws_security_group.test_sg.id}"]
  user_data              = file("${path.module}/script.sh")
  subnet_id              = element(aws_subnet.public_subnet[*].id, count.index)
  tags = {
    Name = "First-${count.index + 1}"
  }
  
}


## VPC SECURITY GROUP IS USED below security group is not ereqired  we used security
## group rather than  **NACL** 





## "${var.private_cidrs[count.index]}"
# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"

#   dynamic "ingress" {
#     for_each = [22, 80]
#     iterator = port
#     content {
#       description = "TLS from VPC"
#       from_port   = port.value
#       to_port     = port.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
