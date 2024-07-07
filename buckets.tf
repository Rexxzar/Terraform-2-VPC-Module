resource "aws_s3_bucket" "log-bucket" {
  bucket        = "my-log-bucket"
  force_destroy = false

  tags = {
    Name = "My log bucket"

  }
}
resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.log-bucket.id
  policy = data.aws_iam_policy_document.S3-IAM.json
}
