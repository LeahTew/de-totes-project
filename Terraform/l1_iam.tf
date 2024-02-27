resource "aws_iam_role" "L1_lambda_role" {
  name = "L1_lambda_role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole"
          ],
          "Principal" : {
            "Service" : [
              "lambda.amazonaws.com"
            ]
          }
        }
      ]
  })
}


data "aws_iam_policy_document" "s3_L1_document" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.ingestion_bucket.arn}",
      "${aws_s3_bucket.code_bucket.arn}"
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*Object"
    ]
    resources = [
      "${aws_s3_bucket.ingestion_bucket.arn}/*",
      "${aws_s3_bucket.code_bucket.arn}/*"
    ]
    effect = "Allow"
  }
    statement {
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::*"

    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "s3_L1_policy" {
  name_prefix = "s3-L1-policy-de-totes-project-"
  policy      = data.aws_iam_policy_document.s3_L1_document.json
}

resource "aws_iam_role_policy_attachment" "L1_S3_policy_attachment" {
  role       = aws_iam_role.L1_lambda_role.name
  policy_arn = aws_iam_policy.s3_L1_policy.arn
}

data "aws_iam_policy_document" "L1_cloudwatch_document" {
  statement {
    actions = ["logs:CreateLogGroup"]

    resources = [
      "arn:aws:logs:eu-west-2:${data.aws_caller_identity.current.account_id}:*"
    ]

    effect = "Allow"
  }

  statement {
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:eu-west-2:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda1}:*"
    ]
  }
}

resource "aws_iam_policy" "L1_cloudwatch_policy" {
  name_prefix = "L1-cloudwatch-policy-de-totes-project-"
  policy      = data.aws_iam_policy_document.L1_cloudwatch_document.json
}

resource "aws_iam_role_policy_attachment" "L1_cloudwatch_policy_attachment" {
  role       = aws_iam_role.L1_lambda_role.name
  policy_arn = aws_iam_policy.L1_cloudwatch_policy.arn
}

data "aws_iam_policy_document" "db_access_doc" {
  statement {
    effect = "Allow"

  principals {
      type        = "AWS"
      identifiers = ["arn:aws:sts::533267264466:assumed-role/L1_lambda_role/extract_handler1"]
    }

    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:eu-west-2:533267264466:secret:totes_secret_aws-XMzaMI"]
  }
}

resource "aws_secretsmanager_secret_policy" "db_access_policy" {
  secret_arn = "arn:aws:secretsmanager:eu-west-2:533267264466:secret:totes_secret_aws-XMzaMI"
  policy     = data.aws_iam_policy_document.db_access_doc.json
}
