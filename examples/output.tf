output "instance_id" {
  value = "${element(aws_instance.web1.*.id, 1)}"
}
output "instance2_id" {
  value = "${element(aws_instance.web1.*.id, 2)}"
}
output "public_subnet1" {
  value = "${element(aws_subnet.public_subnet.*.id, 1 )}"
}
output "public_subnet2" {
  value = "${element(aws_subnet.public_subnet.*.id, 2 )}"
}

output "public_ip1" {
value = "${aws_instance.web1.public_ip2}"
}

output "public_ip1" {
value = "${aws_instance.web1.public_ip2}"
}