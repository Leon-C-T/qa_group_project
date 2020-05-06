resource "aws_cloudwatch_log_group" "pet-codebuild-log-group" {
  name = "codebuild-log-group"
}

resource "aws_cloudwatch_log_stream" "pet-codebuild-stream" {
  name           = "codebuild-stream"
  log_group_name = aws_cloudwatch_log_group.pet-codebuild-log-group.name
}

resource "aws_cloudwatch_event_rule" "code-build-failure" {
  name = "codebuild-failure-capture"
  description = "capture when codebuild fails"

  event_pattern = <<PATTERN
  {
  "source": [
    "aws.codebuild"
  ],
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": [
      "FAILED"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.code-build-failure.name
  target_id = "SendToSNS"
  arn       = var.sns-topic-slack
  
}
  
