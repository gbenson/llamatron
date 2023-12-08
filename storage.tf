resource "aws_s3_bucket" "model_files" {
  bucket = "${local.namespace}models"
}

resource "aws_s3_bucket_ownership_controls" "model_files" {
  bucket = aws_s3_bucket.model_files.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "model_files" {
  depends_on = [aws_s3_bucket_ownership_controls.model_files]

  bucket = aws_s3_bucket.model_files.id
  acl    = "private"
}

resource "aws_iam_policy" "model_file_get" {
  name = "${title(local.codename)}ModelFileGet"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:GetObjectAcl",
      ]
      Resource = [
        aws_s3_bucket.model_files.arn,
        "${aws_s3_bucket.model_files.arn}/*",
      ]
    }]
  })
}

resource "aws_iam_policy" "model_file_put" {
  name = "${title(local.codename)}ModelFilePut"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:AbortMultipartUpload",
      ]
      Resource = [
        aws_s3_bucket.model_files.arn,
        "${aws_s3_bucket.model_files.arn}/*",
      ]
    }]
  })
}
