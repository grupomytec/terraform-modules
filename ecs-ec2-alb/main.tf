#############################
#            ALB            #
#############################

resource "aws_alb" "aws_alb" {
  name            = "${replace(var.app_name, "/\\W|_|\\s/", "-")}-aws-alb" # WARNING change this name dynamic name may cause problems with ecs-service.sh
  security_groups = [aws_security_group.aws_sg_alb.id]
  subnets         = var.subnets

  # tags = merge(local.common_tags, { Name = "${var.cluster_name}-aws_alb" })
}

resource "aws_security_group" "aws_sg_alb" {
  name        = "${replace(var.app_name, "/\\W|_|\\s/", "-")}-sg-alb"
  vpc_id      = var.vpc

  ingress {
    from_port   = var.sg_ingress_from_port
    protocol    = var.sg_ingress_protocol
    to_port     = var.sg_ingress_to_port
    cidr_blocks = var.sg_ingress_cidr_blocks
  }
  egress {
    from_port   = var.sg_egress_from_port
    protocol    = var.sg_egress_protocol
    to_port     = var.sg_egress_to_port
    cidr_blocks = var.sg_egress_cidr_blocks
  }

  # tags = merge(local.common_tags, { Name = "${var.app_name}-sg-alb" })
}

resource "aws_alb_target_group" "aws_alb_target" {
  name        = "${replace(var.app_name, "/\\W|_|\\s/", "-")}-aws-alb-target"
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc
  target_type = "instance"

  health_check {
    path              = var.tg_health_check_path
    healthy_threshold = var.tg_health_check_healthy_threshold
  }
}

resource "aws_alb_listener" "aws_alb_list" {
  load_balancer_arn = aws_alb.aws_alb.arn
  port              = var.alb_port
  protocol          = var.alb_protocol

  default_action {
    type             = var.alb_default_action_type
    target_group_arn = aws_alb_target_group.aws_alb_target.arn
  }
}

resource "local_file" "alb_arn" {
  content            = aws_alb_target_group.aws_alb_target.arn
  filename           = "${path.module}/alb_target_group_arn.txt"
}

resource "local_file" "alb_id" {
  content            = aws_alb_listener.aws_alb_list.arn
  filename           = "${path.module}/alb_listner_arn.txt"
}