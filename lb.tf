resource "aws_lb" "demo" {
  name               = "demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]

  subnets                          = module.vpc.public_subnets
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "demo" {
  load_balancer_arn = aws_lb.demo.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.demo-blue.id
    type             = "forward"
  }
  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

resource "aws_lb_target_group" "demo-blue" {
  name                 = "demo-http-blue"
  port                 = "3000"
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = module.vpc.vpc_id
  deregistration_delay = "30"

  health_check {
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
}
resource "aws_lb_target_group" "demo-green" {
  name                 = "demo-http-green"
  port                 = "3000"
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = module.vpc.vpc_id
  deregistration_delay = "30"

  health_check {
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
}
