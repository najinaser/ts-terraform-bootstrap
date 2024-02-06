provider "aws" {
  region = "eu-west-1"
  profile = "cognito-sandbox"
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

resource "aws_cloudwatch_log_group" "example_lambda" {
  name = "/aws/lambda/${aws_lambda_function.example_lambda.function_name}"

  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


module "product_listing_ads" {
  source = "./modules/product-listing-ads"

  lambda_functions_bucket_name = aws_s3_bucket.lambda_bucket.id
  # lambda_functions_bucket_key = aws_s3_bucket.lambda_bucket.id
  lambda_functions_bucket_key = "deployment-package.zip"

  # s3_bucket = aws_s3_bucket.lambda_bucket.id
  # s3_key    = aws_s3_object.example_lambda.key
}
