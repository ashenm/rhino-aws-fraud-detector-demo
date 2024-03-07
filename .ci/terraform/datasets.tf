locals {
  datasets = {
    transactions-trainset = {
      filename     = "transaction_data_100K_full.csv"
      content_type = "text/csv"
    }
  }
}

resource "aws_s3_object" "datasets" {
  for_each     = local.datasets
  bucket       = aws_s3_bucket.main.bucket
  key          = "datasets/${each.value.filename}"
  source       = "${path.root}/../../datasets/${each.value.filename}"
  source_hash  = filemd5("${path.root}/../../datasets/${each.value.filename}")
  content_type = lookup(each.value, "content_type", null)
}
