provider "aws" {
  region = "eu-west-1" # Replace with your desired AWS region
}

resource "aws_lambda_function" "example_lambda" {
  filename      = "src.zip" # This assumes you have a file named lambda.zip in the same directory
  function_name = "example_lambda_lab"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
}

resource "aws_iam_role" "lambda" {
  name = "example_lambda_role"

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
