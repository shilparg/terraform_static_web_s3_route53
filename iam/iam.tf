data "aws_caller_identity" "current" {}

resource "aws_iam_role" "terraform_static_site_role" {
  name = "TerraformStaticSiteRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_static_site_policy" {
  name        = "TerraformStaticSitePolicy"
  description = "Permissions for hosting static website on S3 with Route 53"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3Access",
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:PutBucketPolicy",
          "s3:PutObject",
          "s3:GetObject",
          "s3:PutBucketWebsite",
          "s3:GetBucketWebsite",
          "s3:PutBucketOwnershipControls",
          "s3:PutBucketPublicAccessBlock"
        ],
        Resource = "*"
      },
      {
        Sid    = "Route53Access",
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.terraform_static_site_role.name
  policy_arn = aws_iam_policy.terraform_static_site_policy.arn
}