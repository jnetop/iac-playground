resource "aws_s3_bucket" "beanstalk_deploys" {
  bucket = "pereira-example3-${var.beanstalk_application_name}-deploys"
}

resource "aws_s3_bucket_object" "docker" {
    depends_on = [
      aws_s3_bucket.beanstalk_deploys
    ]
    bucket = "pereira-example3-${var.beanstalk_application_name}-deploys"
    key    = "${var.beanstalk_application_name}.zip"
    source = "${var.beanstalk_application_name}.zip"
    # The filemd5() function is available in Terraform 0.11.12 and later
    # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
    # etag = "${md5(file("path/to/file"))}"
    etag = filemd5("${var.beanstalk_application_name}.zip")
}