
resource "aws_lambda_function" "import_user" {
  # filename      = "../deployment-package.zip" # This assumes you have a file named lambda.zip in the same directory
  function_name = "import-user-migration"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.example_lambda.key

  role          = aws_iam_role.migration_lambda.arn
  handler       = "import-user-migration.handler"
  runtime       = "nodejs18.x"

  source_code_hash = data.archive_file.lambda-archive-file.output_base64sha256
}

resource "aws_iam_role" "migration_lambda" {
  name = "migration_lambda_role_tr_attach-code_lambda"

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

resource "aws_cloudwatch_log_group" "migration_lambda_logs" {
  name = "/aws/lambda/${aws_lambda_function.import_user.function_name}"

  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "migration_lambda_policy" {
  role       = aws_iam_role.migration_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}