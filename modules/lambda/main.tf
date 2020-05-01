resource "aws_lambda_function" "lambda-snapshot" {
  filename      = "lambda_function_payload.zip"
  function_name = "ec2_bidaily_snapshot"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "lambda_function.snapshot"
  vpc_config {
      subnet_ids         = var.lambda-subnet-ids
      security_group_ids = var.lambda-security-group-ids
  }

  runtime = "python3.8"
  timeout = 40
}

resource "aws_lambda_function" "lambda-recovery" {
  filename      = "lambda_function_payload.zip"
  function_name = "jenkins_recovery_function"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "lambda_function.recovery"
  vpc_config {
      subnet_ids         = var.lambda-subnet-ids
      security_group_ids = var.lambda-security-group-ids
  }

  runtime = "python3.8"
  timeout = 120
}