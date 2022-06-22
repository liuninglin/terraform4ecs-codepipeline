# security group
resource "aws_security_group" "sg_alb" {
  name        = "sg_lb"
  vpc_id      = module.vpc.vpc_id
  description = "Security group settings for application load balancer"
}

resource "aws_security_group" "sg_ecs" {
  name        = "sg_ecs"
  vpc_id      = module.vpc.vpc_id
  description = "Security group settings for ECS"
}

# ============================================================

resource "aws_security_group_rule" "alb-ingress-http80" {
  security_group_id = aws_security_group.sg_alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-egress-nodejs" {
  security_group_id        = aws_security_group.sg_alb.id
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_ecs.id
}

resource "aws_security_group_rule" "alb-egress-django" {
  security_group_id        = aws_security_group.sg_alb.id
  type                     = "egress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_ecs.id
}


# ============================================================


resource "aws_security_group_rule" "ecs-ingress-nodejs" {
  security_group_id        = aws_security_group.sg_ecs.id
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "ecs-ingress-django" {
  security_group_id        = aws_security_group.sg_ecs.id
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "ecs-egress" {
  security_group_id = aws_security_group.sg_ecs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}







# resource "aws_security_group" "sg_ecs" {
#   name        = "sg_ecs"
#   vpc_id      = module.vpc.vpc_id
#   description = "Security group settings for ECS"

#   ingress {
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#   }
# }

# resource "aws_security_group" "sg_alb" {
#   name        = "sg_alb"
#   vpc_id      = module.vpc.vpc_id
#   description = "Security group settings for application load balancer"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 3000
#     to_port   = 3000
#     protocol  = "tcp"
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#   }
# }