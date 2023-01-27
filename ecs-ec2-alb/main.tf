#############################
#            ALB            #
#############################

resource "aws_lb" "aws_alb" {
  name            = "${var.cluster_name}-alb"
  security_groups = [aws_security_group.aws_sg_alb.id]
  subnets         = [aws_subnet.aws_subnets["aws_public_a"].id, aws_subnet.aws_subnets["aws_public_b"].id]

  tags = merge(local.common_tags, { Name = "${var.cluster_name}-alb" })
}

resource "aws_lb_target_group" "aws_lb_target" {
  name     = "${var.cluster_name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path              = "/"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "aws_lb_list" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_target.arn
  }
}