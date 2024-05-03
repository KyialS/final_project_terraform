output "website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.site.id
}

output "domain_name" {
  description = "Website endpoint"
  value       = var.site_domain
}
output "static_website_dns" {
  value = aws_s3_bucket_website_configuration.site.website_endpoint
}