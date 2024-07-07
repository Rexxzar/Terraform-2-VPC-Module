resource "aws_lambda_function" "lambda_function1" {
  filename      = "lambda_function1.zip" # Path to your Lambda function deployment package
  function_name = "lambda-function1"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  tags = {
    Name = "lambda-function1"
  }
}
resource "aws_lambda_function" "lambda_function2" {
  filename      = "lambda_function2.zip" # Path to your Lambda function deployment package
  function_name = "lambda-function2"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "python3.8"

  tags = {
    Name = "lambda-function2"
  }
}