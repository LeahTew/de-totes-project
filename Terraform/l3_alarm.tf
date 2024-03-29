resource "aws_cloudwatch_log_metric_filter" "error_log3" {
  name           = "Lambda3error"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/${var.lambda3}" 

  metric_transformation {
    name      = "ErrorCount"
    namespace = "lambda3_error"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "alert_errors_L3" {
  alarm_name          = "ErrorAlarmL3"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_log3.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.error_log3.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  alarm_description   = "This metric monitors error instances for L3: load_handler3"
  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:sns:eu-west-2:533267264466:bitme-error-alerts"]
  threshold           = 1
}
