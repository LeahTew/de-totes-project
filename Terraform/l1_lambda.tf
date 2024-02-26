# L1 lambda function resource

resource "aws_lambda_function" "lambda1" {
  function_name    = var.lambda1
  role             = aws_iam_role.L1_lambda_role.arn
  handler          = "extract_handler1.lambda_handler"
  runtime          = "python3.10"
  s3_bucket        = aws_s3_bucket.code_bucket.id
  s3_key           = "lambda1/lambda1.zip"
  source_code_hash = data.archive_file.lambda1.output_base64sha256
  architectures = ["arm64"]
  timeout = 120 # need this otherwise it timeouts after 3seconds
  memory_size = 256
  environment {
    variables = {
      S3_ingestion_bucket = "${aws_s3_bucket.ingestion_bucket.id}"
    }
  }
  layers = ["arn:aws:lambda:eu-west-2:336392948345:layer:AWSSDKPandas-Python310-Arm64:11", aws_lambda_layer_version.lambda_layer_dependencies.arn] 
  # we have two layers:
  # - first is a aws made pandas layer - we need specifically python310 and Arm64
  # - second is our layer containing depedencies like pg8000 and all our utility
  #   functions. This is so we can still import like ' from src.extract_handler..
  #   etc which means our tests will still run!
}


# do we need this? as in previous tasks, the bucket has triggered the lambda but here, it is on a schedule
# resource "aws_lambda_permission" "allow_eventbridge" {
#   action         = "lambda:InvokeFunction"
#   function_name  = aws_lambda_function.lambda1.function_name
#   principal      = "events.amazonaws.com"
#   source_arn     = aws_scheduler_schedule.L1_scheduler.arn
#   source_account = data.aws_caller_identity.current.account_id
# }

resource "aws_lambda_layer_version" "lambda_layer_dependencies" {
  layer_name          = "lambda_layer1"
  s3_bucket           = aws_s3_bucket.code_bucket.id
  s3_key              = aws_s3_object.lambda_layer_zip.key
  compatible_runtimes = ["python3.10"]
  source_code_hash    = base64sha256(filebase64("${path.module}/../aws_utils/layer_code1.zip"))
  # We have included a source code hash so that everytime there's an update
  # to our layer_code1.zip file i.e. if we have a new dependency to add
  # it updates automatically.
}
