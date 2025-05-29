#adding locals 
locals {
  common_tags = {
    Name      = "s3"
    project   = "mini s3 project"
    ManagedBy = "Aakansha"
  }
}

#generating random string

resource "random_string" "unique_name" {
  length  = "6"
  special = false
  lower   = true
  upper   = false
}

#creating s3 bucket

resource "aws_s3_bucket" "bucket1" {
  bucket = "my-bucket-${random_string.unique_name.id}"
  tags = merge(local.common_tags, {
    Name = "Bucket"
  })
}

#Adding ownership control to bucket

resource "aws_s3_bucket_ownership_controls" "bucket_owner" {
  bucket = aws_s3_bucket.bucket1.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#adding public access to bucket

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Giving public-read access to bucket

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_owner,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.bucket1.id
  acl    = "public-read"
}

#Adding object in bucket

resource "aws_s3_object" "object_1" {
  bucket = aws_s3_bucket.bucket1.id
  key    = "index.html"
  source = "index.html"
  #acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "object_2" {
  bucket = aws_s3_bucket.bucket1.id
  key    = "main.css"
  source = "main.css"
  #acl          = "public-read"
  content_type = "text/html"
}

/*
resource "aws_s3_object" "object_3" {
  bucket = aws_s3_bucket.bucket1.id
  key    = "mau.jpg"
  source = "mau.jpg"
  acl    = "public-read"
}
*/

#adding website configuration to bucket

resource "aws_s3_bucket_website_configuration" "website_example" {
  bucket = aws_s3_bucket.bucket1.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "main.css"
  }
  depends_on = [aws_s3_bucket_acl.example]
}

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







