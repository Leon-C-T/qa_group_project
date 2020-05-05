resource "aws_cloudwatch_log_group" "pet-codebuild-log-group" {
  name = "codebuild-log-group"
}

resource "aws_cloudwatch_log_stream" "pet-codebuild-stream" {
  name           = "codebuild-stream"
  log_group_name = aws_cloudwatch_log_group.pet-codebuild-log-group.name
}