# # Define the target group: This is going to provide a resource for use with Load Balancer.
resource "aws_lb_target_group" "my-target-group" {
  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
  name        = "demo-tg-alb"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}
# ## # Define the load balancer 

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = tolist(aws_subnet.public_subnet.*.id) 
  tags = {
    Environment = "production"
  }
}


resource "aws_security_group" "alb-sg" {
  name   = "my-alb-sg"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.alb-sg.id}"
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.alb-sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.alb-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}


## # Provides a Load Balancer Listener resource
resource "aws_lb_listener" "my-test-alb-listner" {
  count = 1
  load_balancer_arn = element(aws_lb.test[*].arn , count.index)
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }
}

# # Provides the ability to register instances with an Application Load Balancer (ALB)

resource "aws_lb_target_group_attachment" "ec2-alb-tg-1" {
  count         = var.no_of_public_ec2_ins
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = element(aws_instance.web1[*].id, count.index)
  port             = 80
}



