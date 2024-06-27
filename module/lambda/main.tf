resource "aws_lambda_function" "test_lambda" {

  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"


  source_arn = "${var.execution_arn}/*"
}