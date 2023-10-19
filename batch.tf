resource "aws_batch_compute_environment" "edge" {
  compute_environment_name = "Edge"

  compute_resources {
    ec2_configuration {
      image_type        = "EC2"
      image_id_override = "ami-0c47a507d2c485dff"
    }

    instance_role = aws_iam_instance_profile.ecs_compute_instance_role.arn

    instance_type = [
      "g3s.xlarge",
    ]

    max_vcpus = 1

    subnets = [
      var.private_subnets_ids[0]
    ]

    type = "EC2"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]

  tags = local.tags
}
