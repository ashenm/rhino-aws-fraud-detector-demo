resource "aws_iam_role" "main" {
  name = upper("${local.name_prefix}-frauddetector")

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service" : "frauddetector.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "BucketAccessPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:Describe*", "s3:Get*", "s3:List*"]
          Effect   = "Allow"
          Resource = [aws_s3_bucket.main.arn, "${aws_s3_bucket.main.arn}/datasets/*"]
        }
      ]
    })
  }
}
