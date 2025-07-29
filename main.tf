# Local variables for tags
locals {
  common_tags = {
    Name      = "s3"
    project   = "mini s3 project"
    ManagedBy = "Aakansha"
  }
}

# Random string for unique bucket name
resource "random_string" "unique_name" {
  length  = 6
  special = false
  upper   = false
}

# S3 bucket
resource "aws_s3_bucket" "bucket1" {
  bucket = "my-bucket-${random_string.unique_name.id}"
  tags   = local.common_tags
}

# Ownership controls
resource "aws_s3_bucket_ownership_controls" "bucket_owner" {
  bucket = aws_s3_bucket.bucket1.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public access settings
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ACL
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_owner,
    aws_s3_bucket_public_access_block.public_access
  ]
  bucket = aws_s3_bucket.bucket1.id
  acl    = "public-read"
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.bucket1.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Upload style.css
resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.bucket1.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
}

# Enable website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket1.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Public Read Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket1.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.bucket1.arn}/*"
      }
    ]
  })
}
