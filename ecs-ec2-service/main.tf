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
  # tags               = var.tags
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
          "Resource": "arn:aws:secretsmanager:us-east-1:${var.account_id}:secret:service-*"
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
          "Resource": "arn:aws:sqs:us-east-1:${var.account_id}:service-*"
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
    target_group_arn = var.load_balancer_target_group
    container_name   = var.app_name
    container_port   = var.app_port
  }

}
# CloudWatch Alarms 
resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_up" {
  #count               = "${var.autoscale_rpm_enabled == "true" ? 1 : 0}"
  alarm_name          = "scale-policy-up"
  alarm_description   = "Managed by Terraform"
  alarm_actions       = [aws_autoscaling_policy.ecs_policy_up.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "50"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main.name
  }
}
resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_down" {
  #count               = "${var.autoscale_rpm_enabled == "true" ? 1 : 0}"
  alarm_name          = "scale-policy-down"
  alarm_description   = "Managed by Terraform"
  alarm_actions       = [aws_autoscaling_policy.ecs_policy_down.arn]
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "60"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main.name
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
resource "aws_appautoscaling_policy" "ecs_policy_up" {
  name                    = "${var.cluster_name}/${aws_ecs_service.main.name}-scale-up"
  policy_type             = "StepScaling"
  resource_id             = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 50
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = -10.0
      metric_interval_upper_bound = 0.0
      scaling_adjustment  = -1
    }
    step_adjustment {
      metric_interval_lower_bound = -20.0
      metric_interval_upper_bound = -10.0
      scaling_adjustment = -2
    }
    step_adjustment {
      metric_interval_lower_bound = -30.0
      metric_interval_upper_bound = -20.0
      scaling_adjustment = -3
    }
      step_adjustment {
      metric_interval_upper_bound = -30.0
      scaling_adjustment = -4
    }  
  }
  depends_on = ["aws_appautoscaling_target.main"]
}
resource "aws_appautoscaling_policy" "ecs_policy_down" {
  name                    = "${var.cluster_name}/${aws_ecs_service.main.name}-scale-down"
  policy_type             = "StepScaling"
  resource_id             = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0.0
      metric_interval_upper_bound = 10.0
      scaling_adjustment  = 1
    }
    step_adjustment {
      metric_interval_lower_bound = 10.0
      metric_interval_upper_bound = 20.0
      scaling_adjustment = 2
    }
    step_adjustment {
      metric_interval_lower_bound = 20.0
      metric_interval_upper_bound = 30.0
      scaling_adjustment = 4
    }
      step_adjustment {
      metric_interval_upper_bound = 30.0
      scaling_adjustment = 6
    }  
  }
  depends_on = ["aws_appautoscaling_target.main"]
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
    target_group_arn = var.load_balancer_target_group
  }

  condition {
    path_pattern  {
      values = ["/static/*"]
    }
  }

}