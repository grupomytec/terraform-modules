#############################
#         ECS               #
#############################

resource "aws_ecs_cluster" "foo" {
  name = var.cluster_name
}