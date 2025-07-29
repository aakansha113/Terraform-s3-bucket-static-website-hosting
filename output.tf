output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.bucket1.bucket
}

output "website_url" {
  description = "The URL of the S3 bucket static website"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}
