######################################################################
##                            S3-Bucket                             ##
######################################################################

## Create a bucket
resource "aws_s3_bucket" "index_website" {
  // Bucket name will be user input +  a uui
  bucket = "${var.bucket_name_user_input}----${random_uuid.uuid.result}"
  tags = {
  Environment = "${var.bucket_tag}"
  }
}

## Upload the content to the bucket
resource "aws_s3_object" "content" {
  depends_on = [
    aws_s3_bucket.index_website
  ]
  bucket = aws_s3_bucket.index_website.bucket
  for_each = fileset("/website/", "**/*")
  key = each.value
  source = "./website/${each.value}"
  content_type = lookup(var.MIME_types, lower(regex("[.][^.]+$", each.value)), "application/octet-stream") 
  etag = filemd5("./website/${each.value}")
  server_side_encryption = "AES256"
}

## Create bucket policy for Couldfront access
data "aws_iam_policy_document" "cf_only" {
  depends_on = [
    aws_cloudfront_distribution.static_website,
    aws_s3_bucket.index_website
  ]
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.index_website.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.static_website.arn
      ]
    }
  }
}

## Assign the bucket policy to the bucket
resource "aws_s3_bucket_policy" "cf_only" {
  depends_on = [
    aws_cloudfront_distribution.static_website
  ]
  bucket = aws_s3_bucket.index_website.id
  policy = data.aws_iam_policy_document.cf_only.json
}

## Enable AWS S3 versioning
resource "aws_s3_bucket_versioning" "index_website" {
  bucket = aws_s3_bucket.index_website.bucket
  versioning_configuration {
    status = "Enabled"
  }
}



######################################################################
##                            Cloudfront                            ##
######################################################################

## Create a CloudFront distribution 
resource "aws_cloudfront_distribution" "static_website" {
  depends_on = [
    aws_s3_bucket.index_website,
    aws_cloudfront_origin_access_control.static_website
  ]

  origin {
    domain_name              = aws_s3_bucket.index_website.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.index_website.id
    origin_access_control_id = aws_cloudfront_origin_access_control.static_website.id
  }

  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.index_website.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

## Create Origin Access Control 
resource "aws_cloudfront_origin_access_control" "static_website" {
  name                              = "OAC-for-${var.bucket_name_user_input}"
  description                       = "OAC-S3-policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}