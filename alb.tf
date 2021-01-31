resource "aws_security_group" "alb" {
  name = "ALB-SG"
  description = "Load Balancer SG"
  vpc_id = "vpc-0a8eae70"

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Terraform Load Balancer"
    from_port = 80
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = 80
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Terraform Load Balancer"
    from_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]

  tags = {
    Name = "Load Balancer"
  }
}

resource "aws_lb" "this" {
  name = "ALB"
  security_groups = [ "${aws_security_group.alb.id}" ]
  subnets = [ "subnet-e62434ba", "subnet-93f3e1bd" ]

  tags = {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "tg" {
  name = "ALB-TG"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-0a8eae70"

  health_check {
    path = "/"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "lbl" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }
  #certificate_arn = "${aws_acm_certificate_validation.name.certificate_arn}"
}