# Output the S3 bucket name
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.web_app_bucket.bucket
}

# Output the S3 bucket website endpoint
output "s3_bucket_website_endpoint" {
  description = "The website endpoint for the S3 bucket"
  value       = aws_s3_bucket_website_configuration.web_app_bucket_website.website_endpoint
}

# Output the IAM user access key ID
output "iam_user_access_key_id" {
  description = "The access key ID for the IAM user"
  value       = aws_iam_access_key.s3_access_key.id
  sensitive   = true
}

# Output the IAM user secret access key
output "iam_user_secret_access_key" {
  description = "The secret access key for the IAM user"
  value       = aws_iam_access_key.s3_access_key.secret
  sensitive   = true
}