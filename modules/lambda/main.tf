resource "aws_lambda_function" "lambda-snapshot" {
  filename      = "../../payloads/snapshot.zip"
  function_name = "ec2_quadrantdiurnal_snapshot"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "snapshot.lambda_handler"

  runtime = "python3.8"
  timeout = 10
}

resource "aws_lambda_function" "lambda-cleanup" {
  filename      = "../../payloads/cleanup.zip"
  function_name = "ec2_diurnal_cleanup"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "cleanup.lambda_handler"

  runtime = "python3.8"
  timeout = 5
}

resource "aws_lambda_function" "lambda-image" {
  filename      = "../../payloads/image.zip"
  function_name = "snapshot_image_converter"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "image.lambda_handler"

  runtime = "python3.8"
  timeout = 5
}

resource "aws_lambda_function" "lambda-recovery" {
  filename      = "../../payloads/recovery.zip"
  function_name = "jenkins_recovery_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "recovery.lambda_handler"

  runtime = "python3.8"
  timeout = 10
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "Lambda-Role"

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

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda-EC2InstanceConnect" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda-AWSLambdaFullAccess"{
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
  role = aws_iam_role.iam_for_lambda.name
}