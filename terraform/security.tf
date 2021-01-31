resource "aws_security_group" "lb" {
  name = "${local.app_name}-load-balancer-security-group"
  description = "controll access to the ALB"
  vpc_id = aws_vpc.this.id

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = ""
    from_port = var.app_port
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = var.app_port
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = ""
    from_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]
}
resource "aws_security_group" "ecs_tasks" {
  name = "${local.app_name}-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id = aws_vpc.this.id

  ingress = [ {
    cidr_blocks = []
    description = ""
    from_port = var.app_port
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = [ aws_security_group.lb.id ]
    self = false
    to_port = var.app_port
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = ""
    from_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]
}