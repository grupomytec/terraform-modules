#############################
#         ECR               #
#############################

# Create ECR Repository
resource "aws_ecr_repository" "main" {
  name = var.app_name
  # tags = var.tags
}

# Lifecycle policy
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.ecr_retention} of images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.ecr_retention}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}


#############################
#         Security          #
#############################

# Create Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_exec_role" {
  name               = "ECSTaskExecRole-${var.app_name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
          "Service": [
              "ecs-tasks.amazonaws.com"
          ]
          },
          "Effect": "Allow",
          "Sid": ""
        }
    ]
}
EOF
  # tags              = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_role" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_exec_role_policy" {
  name = "ExecRole-${var.app_name}"
  role = aws_iam_role.ecs_task_exec_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # policy = var.task_exec_role
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
              "secretsmanager:GetResourcePolicy",
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret",
              "secretsmanager:ListSecretVersionIds",
              "secretsmanager:TagResource"
          ],
          "Resource": "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"
      }
  ]
}
EOF
}

# Create Role for ECS Task 
resource "aws_iam_role" "ecs_task_role" {
  name               = "ECSTaskRole-${var.app_name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
          "Service": [
              "ecs-tasks.amazonaws.com"
          ]
          },
          "Effect": "Allow",
          "Sid": ""
        }
    ]
}
EOF
  # tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name = "Role-${var.app_name}"
  role = aws_iam_role.ecs_task_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # policy = var.task_role
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor1",
          "Effect": "Allow",
          "Action": "sqs:*",
          "Resource": "arn:aws:sqs:${var.region}:${var.account_id}:*"
      }
  ]
}
EOF
}

# Create Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = var.app_name
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = <<EOF
[
  {
    "cpu": ${var.cpu},
    "image": "${aws_ecr_repository.main.repository_url}:latest",
    "memory": ${var.memory},
    "name": "${var.app_name}",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${var.app_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "environment" : ${var.task_environment},
    "secrets": ${var.task_secrets}
  }
]
EOF
}

# CloudWatch Group
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = var.logs_retention
  # tags              = var.tags
}

# Create Service
resource "aws_ecs_service" "main" {
  name            = "${var.app_name}"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.min_capacity
  launch_type     = "EC2"


  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = var.app_name
    container_port   = var.app_port
  }

}

# Target Group to App
resource "aws_alb_target_group" "main" {
  name        = "${var.app_name}-${random_string.random.result}"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    interval            = var.tg-interval
    path                = var.tg-path
    timeout             = var.tg-timeout
    matcher             = var.tg-matcher
    healthy_threshold   = var.tg-healthy_threshold
    unhealthy_threshold = var.tg-unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Autoscaling Target
resource "aws_appautoscaling_target" "main" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  role_arn           = "arn:aws:iam::${var.account_id}:role/ecsAutoscaleRole"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# Autoscaling Policy
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.main.resource_id
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension
  service_namespace  = aws_appautoscaling_target.main.service_namespace

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = var.metric_type
    }

    target_value = var.target_value
  }
}

resource "random_string" "random" {
  length           = 3
  special          = false
  lower            = true
 }

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener_rule" "main" {
  listener_arn = var.load_balancer_listner

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }

  condition {
    host_header {
      values = ["${var.sub_domain}"]
    }
  }

}
