#  Provider Configuration
provider "aws" {
  region = var.aws_region
}

#  Create an S3 bucket for hosting the static website
resource "aws_s3_bucket" "web_app_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

#  Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "web_app_bucket_website" {
  bucket = aws_s3_bucket.web_app_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#  Block public ACLs but allow public access via a bucket policy
resource "aws_s3_bucket_public_access_block" "web_app_bucket_access" {
  bucket = aws_s3_bucket.web_app_bucket.bucket

  block_public_acls       = true   # Prevents ACL usage
  block_public_policy     = false  # Allows bucket policy to control access
  ignore_public_acls      = true   # Ignores ACL settings
  restrict_public_buckets = false  # Allows bucket policy to enable public access
}

#  Add a public bucket policy (since ACLs are disabled)
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.web_app_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = [
          "${aws_s3_bucket.web_app_bucket.arn}/*"
        ]
      }
    ]
  })
}

#  Create an IAM user with programmatic access (Used by GitHub Actions)
resource "aws_iam_user" "s3_access_user" {
  name = "${var.project_name}-s3-user"
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

#  Create an IAM access key for the user
resource "aws_iam_access_key" "s3_access_key" {
  user = aws_iam_user.s3_access_user.name
}

#  Create an IAM policy for S3 access (Used by GitHub Actions)
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.project_name}-s3-access-policy"
  description = "Policy to allow access to the S3 bucket for the web application"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.web_app_bucket.arn,
          "${aws_s3_bucket.web_app_bucket.arn}/*"
        ]
      }
    ]
  })
}

#  Attach the IAM policy to the IAM user
resource "aws_iam_user_policy_attachment" "s3_access_attachment" {
  user       = aws_iam_user.s3_access_user.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
