resource "aws_iam_role" "product_listing_ads_lambda_iam_role" {
  name = "feedonomics_ads_lambda_iam_role"

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


resource "aws_lambda_function" "product_list_ads_lambda" {
  function_name     = "feedonomics-product-list-ads-${var.env}"
  role              = aws_iam_role.product_listing_ads_lambda_iam_role.arn
  handler           = "index.handler"
  runtime           = "nodejs18.x"
  timeout           = 300

  s3_bucket         = var.lambda_functions_bucket_name
  s3_key            = var.lambda_functions_bucket_key
}

resource "aws_cloudwatch_log_group" "feedonomics_product_list_ads" {
  name = "/aws/lambda/${aws_lambda_function.product_list_ads_lambda.function_name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_iam_role_policy_attachment" "feedonomics_product_lambda_policy" {
  role       = aws_iam_role.product_listing_ads_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_event_rule" "feedonomics_product_lambda_trigger" {
  name                = "feedonomics-product-lambda-trigger-${var.env}"
  description         = "Weekly trigger the lambda to prepare the data"
  # schedule_expression = "cron(0 0 ? * SUN *)"
  schedule_expression = "cron(*/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "feedonomics_product_list_event_target" {
  rule = aws_cloudwatch_event_rule.feedonomics_product_lambda_trigger.name
  arn  = aws_lambda_function.product_list_ads_lambda.arn
}

resource "aws_lambda_permission" "feedonomics_product_list_event_target" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.product_list_ads_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.feedonomics_product_lambda_trigger.arn
}
