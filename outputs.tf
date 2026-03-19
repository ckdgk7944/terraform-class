output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.demo.id
}

output "ec2_public_ip" {
  value = aws_instance.demo.public_ip
}

output "demo_s3_bucket" {
  value = aws_s3_bucket.demo_public.id
}

output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}

output "access_analyzer_arn" {
  value = aws_accessanalyzer_analyzer.main.arn
}
