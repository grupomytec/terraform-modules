#############################
#         ECS               #
#############################

# Create a ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "role" {
  name = "test-mt-aws_iam_role"
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
  name = "test-mt-aws_iam_instance_profile"
  role = aws_iam_role.role.name
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "test-mt-launch_template"
  image_id      = "ami-07da26e39622a03dc"
  instance_type = "t2.micro"
  user_data = var.user_data

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "test-mt-aws_autoscaling_group"
  protect_from_scale_in = true

  availability_zones = ["us-east-1a"]
  default_cooldown   = 5
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "test-mt-capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.autoscaling_group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = var.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}