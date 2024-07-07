resource "aws_cloudtrail" "my-cloud-trail" {


  name                          = "My-Trail"
  s3_bucket_name                = aws_s3_bucket.log-bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
}

