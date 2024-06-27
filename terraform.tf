

module "lambda" {
  source        = "./module/lambda"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = var.runtime
  function_name = var.function_name
  handler       = var.handler
  filename      = var.filename
  execution_arn = module.API_REST.execution_arn
}

module "API_REST" {
  source      = "./module/API_REST"
  API_name    = var.API_name
  API_types   = var.API_types
  stage_name  = var.stage_name
  path_part   = var.path_part
  GET_METHOD  = var.GET_METHOD
  POST_METHOD = var.POST_METHOD
  uri         = module.lambda.invoke_arn
  depends_on = [ module.lambda.invoke_arn ]
}



## PART ::: IAM 

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_exec.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}