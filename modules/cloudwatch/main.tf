resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = <<EOF
  {
   "widgets": [
       {
            "type":"metric",
            "width":18,
            "height":9,
            "properties":{
                "metrics":[
                [ { "expression": "SEARCH('InstanceType="t2.small" Namespace="AWS/EC2" MetricName=\"CPUUtilization\"', 'Average', 300)", "id": "e1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "title":"EC2 Instance CPU"
            }
         }
       {
            "type":"metric",
            "width":12,
            "height":6,
            "properties":{
                "metrics":[
                [ "AWS/EC2", "DiskReadBytes", "InstanceId", "i-123",{ "id": "m1" } ],
                [ ".", ".", ".", "i-abc", { "id": "m2" } ],
                [ { "expression": "SUM(METRICS())", "label": "Sum of DiskReadbytes", "id": "e3" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "period":300,
                "stat":"Average",
                "title":"EC2 Instance CPU"
            }
         }
   ]
  }
  EOF
}

resource "aws_cloudwatch_event_rule" "rate-schedule" {
  name = "cloudwatch-event-lambda-snapshot"
  description = "This event will run every 12 hours"
  schedule_expression = rate(12 hours)
  is_enabled = true
}
resource "aws_cloudwatch_event_target" "snapshot-target" {
  rule = aws_cloudwatch_event_rule.rate-schedule.name
  arn  = var.snapshot-arn
}

resource "aws_cloudwatch_event_target" "image-target" {
  target_id = "image"
  rule      = "${aws_cloudwatch_event_rule.image.name}"
  arn       = var.image-arn

resource "aws_cloudwatch_event_rule" "image" {
  name        = "check-for-new-snapshots"
  description = "Checks for new snapshots and triggers image conversion"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EBS Snapshot Notification"
  ],
  "detail": {
    "event": [
      "createSnapshot"
    ],
    "result": [
      "succeeded"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_metric_alarm" "jenkins-health-alarm" {
  alarm_name          = "JenkinsAlarm"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  alarm_description   = "Is the Jenkins server healthy"
  actions_enabled     = "true"
  alarm_actions       = var.recovery-arn
  ok_actions          = var.recovery-arn
  dimensions = {
    InstanceId = var.jenkins-id
  }
}