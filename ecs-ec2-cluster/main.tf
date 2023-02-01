#############################
#            ECS            #
#############################
# Create a ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}
resource "aws_iam_role" "role" {
  name = "${var.app_name}-iam_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachment_ssm_managed_instance_core" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "attachment_ec2_container_service_for_ec2_role" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.app_name}-iam_instance_profile"
  role = aws_iam_role.role.name
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.app_name}-launch_template"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = var.user_data

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "${var.app_name}-autoscaling_group"
  protect_from_scale_in = true
  force_delete          = true

  availability_zones = [var.availability_zones]
  default_cooldown   = var.default_cooldown
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "${var.app_name}-capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.autoscaling_group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = var.maximum_scaling_step_size
      minimum_scaling_step_size = var.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = var.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    base              = var.base
    weight            = var.weight
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}