provider "aws" {
  region = "eu-west-1"
  access_key = ""
  secret_key = ""
}

resource "aws_lambda_function" "example_lambda" {
  filename      = "../deployment-package.zip" # This assumes you have a file named lambda.zip in the same directory
  function_name = "attach-code-to-jwt-terraform"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

resource "aws_iam_role" "lambda" {
  name = "example_lambda_role_tr_attach-code_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}
