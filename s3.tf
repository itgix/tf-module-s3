#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-block-public-acls
#tfsec:ignore:aws-s3-block-public-policy
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-ignore-public-acls
#tfsec:ignore:aws-s3-no-public-buckets
#tfsec:ignore:aws-s3-specify-public-access-block
module "s3_bucket" {
  for_each            = { for bucket in var.bucket_configuration : bucket.bucket_name_prefix => bucket }
  source              = "cloudposse/s3-bucket/aws"
  version             = "~> 3.1.2"
  name                = "${local.bucket_name_prefix}"
  acl                 = each.value.acl_type
  user_enabled        = each.value.create_s3_user
  versioning_enabled  = each.value.versioning_enabled
  sse_algorithm       = each.value.sse_algorithm
  ssm_base_path       = "/${local.bucket_name_prefix}-s3-user/"
  cors_configuration  = each.value.cors_configuration
  block_public_acls   = each.value.block_public_acls != null ? each.value.block_public_acls : true
  block_public_policy = each.value.block_public_policy != null ? each.value.block_public_policy : true
  ignore_public_acls  = each.value.ignore_public_acls != null ? each.value.ignore_public_acls : true
  logging = ({
    bucket_name = coalesce(each.value.logging_bucket_name, local.logging_bucket_name)
    prefix      = "s3accesslogs/${local.bucket_name_prefix}-${each.value.bucket_name_prefix}/"
  })
  restrict_public_buckets      = each.value.restrict_public_buckets != null ? each.value.restrict_public_buckets : true
  privileged_principal_arns    = each.value.privileged_principal_arns != null ? each.value.privileged_principal_arns : []
  privileged_principal_actions = each.value.privileged_principal_actions != null ? each.value.privileged_principal_actions : []
}
