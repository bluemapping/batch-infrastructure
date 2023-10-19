resource "aws_batch_compute_environment" "edge" {
  compute_environment_name = "Edge"

  compute_resources {
    ec2_configuration {
      image_type = "ECS_AL2_NVIDIA"
    }

    instance_role = aws_iam_instance_profile.ecs_compute_instance_role.arn

    instance_type = [
      "g3s.xlarge",
    ]

    min_vcpus     = 0
    max_vcpus     = 1
    desired_vcpus = 0

    subnets = [
      var.private_subnets_ids[0]
    ]

    security_group_ids = ["sg-0d7939fc6ec728231"]

    type = "EC2"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  state        = "ENABLED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]

  tags = local.tags
}
