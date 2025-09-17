output "ec2_public_ip" {
  value = aws_instance.backup_api.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backup.bucket
}
