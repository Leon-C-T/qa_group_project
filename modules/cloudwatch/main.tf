resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = <<EOF
  {
    "widgets": [
      {
        "type":"metric",
        "x":0,
        "y":0,
        "width":18,
        "height":9,
        "properties":{
          "metrics":[
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${var.jenkins-id}"
            ]
          ],
          "period": 300,
          "stat": "Average",
          "region":"${var.region}",
          "title":"Jenkins Instance CPU"
        }
      },
      {
        "type":"metric",
        "x":0,
        "y":19,
        "width":12,
        "height":6,
        "properties":{
          "metrics":[
          [ "AWS/EC2", "DiskReadBytes", "InstanceId", "${var.jenkins-id}",{ "id": "m1" } ],
          [ ".", ".", ".", "${var.jenkins-id}", { "id": "m2" } ],
          [ { "expression": "SUM(METRICS())", "label": "Sum of DiskReadbytes", "id": "e3" } ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "period":300,
          "stat":"Average",
          "region":"${var.region}",
          "title":"Jenkins Disk Usage"
        }
      }
    ]
  }
  EOF
}

resource "aws_cloudwatch_event_rule" "rate-schedule" {
  name = "cloudwatch-event-lambda-snapshot"
  description = "This event will run every 6 hours"
  schedule_expression = "rate(6 hours)" #cron(0 0 */6 ? * *)
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "snapshot-target" {
  rule = aws_cloudwatch_event_rule.rate-schedule.name
  arn  = var.snapshot-arn
}

resource "aws_cloudwatch_event_rule" "daily-schedule" {
  name = "cloudwatch-event-snapshot-cleanup"
  description = "This event will once a day at 10pm"
  schedule_expression = "cron(0 22 * * ? *)"
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "cleanup-target" {
  rule = aws_cloudwatch_event_rule.daily-schedule.name
  arn  = var.cleanup-arn
}

resource "aws_cloudwatch_event_target" "image-target" {
  target_id  = "image"
  rule       = aws_cloudwatch_event_rule.image.name
  arn        = var.image-arn
}

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
  alarm_actions       = var.topic-lambdarecovery-arn
  #ok_actions          = var.recovery-arn  list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name (ARN).
  dimensions = {
    InstanceId = var.jenkins-id
  }
}