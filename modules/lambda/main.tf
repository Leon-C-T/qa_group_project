resource "aws_lambda_function" "lambda-slacknotif" {
  filename      = "../../modules/payloads/slack-notif.zip"
  function_name = "slack-notif-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "slack-notif.lambda_handler"
  environment {
    variables = {
      "SLACK_CHANNEL" = "team1",
      "SLACK_USER"    = "CodeBuild",
      "SLACK_WEBHOOK_URL" = "https://hooks.slack.com/services/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"
    }
  }
  runtime = "python2.7"
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

resource "aws_iam_role_policy_attachment" "lambda-EC2InstanceConnect" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda-CloudWatchLogsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.iam_for_lambda.name
}