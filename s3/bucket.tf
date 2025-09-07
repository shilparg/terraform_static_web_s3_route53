resource "aws_s3_bucket" "shilpas3_site" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "ShilpaS3Site"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.shilpas3_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.shilpas3_site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.shilpas3_site.id

 # Allow public policies to be applied

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "shilpas3_policy" {
  bucket = aws_s3_bucket.shilpas3_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.shilpas3_site.arn}/*"
      }
    ]
  })
}

# resource "aws_s3_object" "index" {
#   bucket       = aws_s3_bucket.shilpas3_site.id
#   key          = "index.html"
#   source       = "site/index.html"
#   content_type = "text/html"
# }

# resource "aws_s3_object" "error" {
#   bucket       = aws_s3_bucket.shilpas3_site.id
#   key          = "error.html"
#   source       = "site/error/index.html"
#   content_type = "text/html"
# }

resource "aws_s3_object" "site_assets" {
  for_each = fileset("site", "**")

  bucket = aws_s3_bucket.shilpas3_site.id
  key    = each.value
  source = "site/${each.value}"

  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      png  = "image/png"
      jpg  = "image/jpeg"
      jpeg = "image/jpeg"
      svg  = "image/svg+xml"
      woff = "font/woff"
      woff2 = "font/woff2"
      ttf  = "font/ttf"
      eot  = "application/vnd.ms-fontobject"
      json = "application/json"
    },
    lower(regex("[^.]+$", each.value)),
    "application/octet-stream"
  )
}