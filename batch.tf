resource "aws_batch_compute_environment" "small" {
  compute_environment_name_prefix = "small_"

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

resource "aws_batch_job_definition" "simulation_edge_small" {
  name                  = "simulation_job_edge"
  type                  = "container"
  platform_capabilities = ["EC2"]

  container_properties = jsonencode({
    image : var.compute_image_most_recent

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "1"
      },
      {
        type  = "MEMORY"
        value = "512"
      },
      #      {
      #        type  = "GPU"
      #        value = "1"
      #      }
    ]

    logConfiguration : {
      logDriver : "awslogs",
      options : {
        awslogs-create-group : "true",
        awslogs-group : "/batch/${var.project}",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "batch"
      }
    }

    environment = [
      {
        name  = "VARNAME"
        value = "VARVAL"
      }
    ]
  })
}

resource "aws_batch_job_queue" "edge_queue" {
  name     = "edge-queue"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.small.arn,
  ]
}
