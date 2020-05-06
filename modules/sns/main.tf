resource "aws_sns_topic" "topic-lambdaslack" {
  name = "lambda-trigger"
}

resource "aws_sns_topic_subscription" "slack-notification" {
  topic_arn = aws_sns_topic.topic-lambdaslack.arn
  protocol  = "lambda"
  endpoint  = var.slack-arn
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.topic-lambdaslack.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.topic-lambdaslack.arn]
  }
}

#{
#  "Version": "2012-10-17",
#  "Id": "default",
#  "Statement": [
#    {
#      "Sid": "sns-eu-west-2-302907371563-pipelines-failure-event",
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "sns.amazonaws.com"
#      },
#      "Action": "lambda:invokeFunction",
#      "Resource": "arn:aws:lambda:eu-west-2:302907371563:function:slack_alerts",
#      "Condition": {
#        "ArnLike": {
#          "AWS:SourceArn": "arn:aws:sns:eu-west-2:302907371563:pipelines-failure-event"
#        }
#      }
#    }
#  ]
#}