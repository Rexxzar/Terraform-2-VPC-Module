data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_iam_policy_document" "S3-IAM" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.log-bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:us-east-1:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log-bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:us-east-1:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }
}

resource "aws_iam_role" "secret_manager_role" {
  name = "example-secret-manager-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "rds.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "example-secret-manager-role"
  }
}

# IAM Policy for Secrets Manager Access
data "aws_iam_policy_document" "secret_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.db_secret.arn
    ]
  }
}

resource "aws_iam_policy" "secret_manager_policy" {
  name        = "example-secret-manager-policy"
  description = "Allows RDS instance to access Secrets Manager secret"
  policy      = data.aws_iam_policy_document.secret_manager_policy.json
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "secret_manager_attachment" {
  role       = aws_iam_role.secret_manager_role.name
  policy_arn = aws_iam_policy.secret_manager_policy.arn
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "lambda-execution-role"
  }
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda-execution-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}

