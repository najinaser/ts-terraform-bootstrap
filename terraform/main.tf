provider "aws" {
  region = "eu-west-1"
  access_key = "xx"
  secret_key = "xx/yy"
}

# https://github.com/antonputra/tutorials/tree/main/lessons/115

terraform{
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
  }
}



data "archive_file" "lambda-archive-file" {
  type = "zip"

  source_dir  = "../${path.module}/dist"
  output_path = "../${path.module}/deployment-package.zip"
}

resource "aws_lambda_function" "example_lambda" {
  # filename      = "../deployment-package.zip" # This assumes you have a file named lambda.zip in the same directory
  function_name = "attach-code-to-jwt-terraform"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.example_lambda.key

  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  source_code_hash = data.archive_file.lambda-archive-file.output_base64sha256
}

resource "aws_s3_object" "example_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "deployment-package.zip"
  source = data.archive_file.lambda-archive-file.output_path

  etag = filemd5(data.archive_file.lambda-archive-file.output_path)
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
