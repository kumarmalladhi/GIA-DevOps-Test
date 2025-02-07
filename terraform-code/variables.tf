# AWS Region
variable "aws_region" {
  description = "The AWS region where resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

# S3 Bucket Name
variable "bucket_name" {
  description = "The name of the S3 bucket for the web application"
  type        = string
}

# Environment (e.g., dev, staging, prod)
variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, staging, prod)"
  type        = string
}

# Project Name
variable "project_name" {
  description = "The name of the project"
  type        = string
}