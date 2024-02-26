# resource "aws_scheduler_schedule" "L1_scheduler" {
#   name = "L1_scheduler"
#   flexible_time_window {
#     mode = "OFF"
#   }

#   schedule_expression = "rate(5 minutes)"

#   target {
#     arn      = aws_lambda_function.lambda1.arn
#     role_arn = aws_iam_role.L1_eventbridge_role.arn
#   }
# }

resource "aws_cloudwatch_event_rule" "scheduler" {
    name_prefix = "${var.lambda1}-"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_lambda_permission" "allow_scheduler" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda1.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.scheduler.arn
  source_account = data.aws_caller_identity.current.account_id
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.scheduler.name
  arn       = aws_lambda_function.lambda1.arn
}