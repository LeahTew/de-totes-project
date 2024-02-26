data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda1" {
  type        = "zip"
  source_dir = "${path.module}/../src/extract_handler1"
  output_path = "${path.module}/../lambda1.zip"
}

data "archive_file" "layer_code1" {
  type        = "zip"
  source_dir = "${path.module}/../aws_utils/layer_code1"
  output_path = "${path.module}/../aws_utils/layer_code1.zip"
}

# ORIGINAL LAYER:
# data "archive_file" "lambda1_layer" {
#   type        = "zip"
#   source_file  = "${path.module}/../src/layers/L1-layer/requirements.txt"
#   output_path = "${path.module}/../lambda_layer.zip"
# }

# data "archive_file" "lambda2" {
#   type        = "zip"
#   source_file = "${path.module}/../src/lambda2/lambda2.py"
#   output_path = "${path.module}/../lambda2.zip"
# }

# data "archive_file" "lambda3" {
#   type        = "zip"
#   source_file = "${path.module}/../src/lambda3/lambda3.py"
#   output_path = "${path.module}/../lambda3.zip"
# }
#