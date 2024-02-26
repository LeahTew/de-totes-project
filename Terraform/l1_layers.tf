#define variables
locals {
  layer_path        = "lambda1_layer"
  layer_zip_name    = "lambda1_layer.zip"
  layer_name        = "lambda1_dep_layer"
  requirements_name = "requirements.txt"
  requirements_path = "${path.module}/../src/layers/L1-layer/requirements.txt"
}

# create zip file from requirements.txt. Triggers only when the file is updated
# resource "null_resource" "lambda_layer" {
#   triggers = {
#     requirements = filesha1(local.requirements_path)
#   }
#   # the command to install python and dependencies to the machine and zips
#   provisioner "local-exec" {
#     command = <<EOT
#       cd ${local.layer_path}
#       rm -rf python
#       mkdir python
#       pip3 install -r ${local.requirements_name} -t python/
#       zip -r ${local.layer_zip_name} python/
#     EOT
#   }
# }

# upload zip file to s3
resource "aws_s3_object" "lambda_layer_zip" {
  bucket = aws_s3_bucket.code_bucket.id
  key    = "ingestion_code_layer/layer_code1.zip"
  source = "${path.module}/../aws_utils/layer_code1.zip"
  source_hash = filemd5("${path.module}/../aws_utils/layer_code1.zip")
  # ^^ This auto-updates the s3 bucket/key that holds our layer_code1.zip
  # (has all the dependencies)
}

# create lambda layer
# resource "aws_lambda_layer_version" "lambda_layer" {
#   layer_name          = "lambda1-layer"
#   filename            = data.archive_file.lambda1_layer.output_path
#   source_code_hash    = data.archive_file.lambda1_layer.output_base64sha256
#   compatible_runtimes = ["python3.10"]
#   depends_on          = [aws_s3_object.lambda_layer_zip] # triggered only if the zip file is uploaded to the bucket
# }
