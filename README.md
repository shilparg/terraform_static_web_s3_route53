# terraform_static_web_s3_route53

terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── s3/
│ ├── bucket.tf
│ ├── iam.tf
├── route53/
│ ├── dns.tf

==============
Walk through how this Terraform code works—step by step—so we can see how each piece contributes to deploying a secure, production-grade static website on AWS using S3 and Route 53.
==============

## 1. **Provider Initialization**

```hcl
provider "aws" {
  region = var.region
}
```

This tells Terraform to use the AWS provider and deploy resources in the region specified by `var.region` (e.g., `us-east-1`).

---

## 2. **S3 Bucket for Static Website**

```hcl
resource "aws_s3_bucket" "shilpas3_site" { ... }
```

Creates an S3 bucket named `shilpas3.sctp-sandbox.com` to host the static site. `force_destroy = true` allows Terraform to delete the bucket even if it contains files.

### Website Configuration

```hcl
resource "aws_s3_bucket_website_configuration" "site_config" { ... }
```

Enables static website hosting on the bucket, specifying `index.html` and `error.html` as entry points.

---

## 3. **Security Controls**

### Ownership Enforcement

```hcl
resource "aws_s3_bucket_ownership_controls" "ownership" { ... }
```

Ensures that the bucket enforces ownership by the bucket owner—important for avoiding ACL conflicts.

### Public Access Block

```hcl
resource "aws_s3_bucket_public_access_block" "public_access" { ... }
```

Blocks public ACLs and policies unless explicitly allowed. This is a security best practice.

### Bucket Policy for Public Read

```hcl
resource "aws_s3_bucket_policy" "shilpas3_policy" { ... }
```

Grants public read access to objects in the bucket using a policy that allows `s3:GetObject` for all users (`Principal = "*"`) on all objects (`arn/*`).

---

## 4. **Uploading Website Files**

```hcl
resource "aws_s3_object" "index" { ... }
resource "aws_s3_object" "error" { ... }
```

Uploads my `index.html` and `error.html` files to the bucket. These are the actual content users will see when visiting my site.

---

## 5. **Route 53 DNS Configuration**

### Hosted Zone Lookup

```hcl
data "aws_route53_zone" "sandbox" { ... }
```

Fetches the hosted zone for `sctp-sandbox.com` so I can create DNS records within it.

### DNS Record Creation

```hcl
resource "aws_route53_record" "shilpas3" { ... }
```

Creates an `A` record pointing `shilpas3.sctp-sandbox.com` to the S3 website endpoint using an alias. This makes my site accessible via a custom domain.

---

## 6. **IAM Role and Policy**

### IAM Role

```hcl
resource "aws_iam_role" "terraform_static_site_role" { ... }
```

Defines a role that Terraform can assume to manage resources securely.

### IAM Policy

```hcl
resource "aws_iam_policy" "terraform_static_site_policy" { ... }
```

Grants permissions to manage S3 and Route 53 resources—like creating buckets, uploading files, and updating DNS records.

### Role-Policy Attachment

```hcl
resource "aws_iam_role_policy_attachment" "attach_policy" { ... }
```

Attaches the policy to the role so it can be used effectively.

---

## 7. **Variables and tfvars**

Defined variables like `bucket_name`, `region`, and `domain_name` in `variables.tf`, and initialized them dynamically in `terraform.tfvars`. This makes my code reusable and environment-agnostic.

---

## 8. **Outputs**

```hcl
output "bucket_name" { ... }
output "website_endpoint" { ... }
output "route53_record" { ... }
```

These give us visibility into key resources after deployment—useful for debugging, documentation, or chaining into other modules.

---

## Summary

This setup:

- Deploys a static site securely on S3
- Configures DNS with Route 53
- Uploads content and sets up public access
- Uses IAM roles and policies for secure automation
- Modularizes variables and outputs for clarity and reuse
