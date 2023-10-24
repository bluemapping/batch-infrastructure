variable "terraform_organization" {
  type        = string
  description = "The organization name on terraform cloud"
  nullable    = false
}

variable "tfe_token" {
  description = "TFE Team token"
  nullable    = false
  default     = false
  sensitive   = true
}

variable "project" {
  type        = string
  nullable    = false
  description = "The name of the project that hosts the environment"
}

variable "service" {
  type        = string
  nullable    = false
  description = "The name of the service that will be run on the environment"
}

variable "private_subnets_ids" {
  type        = list(string)
  nullable    = false
  description = "The ids of the project vpc private subnets where the compute environments are hosted"
}

variable "compute_image_most_recent" {
  type        = string
  nullable    = false
  description = "The latest compute image released on the ECR repository"
}
