resource "aws_sns_topic" "topic-lambdarecovery" {
  name = "lambda-trigger"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.topic-lambdarecovery.arn
  protocol  = "lambda"
  endpoint  = var.recovery-arn
}