variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "Region to deploy"
}

variable "environment" {
  default     = "prod"
  type        = string
  description = "Deployment stage name"
}