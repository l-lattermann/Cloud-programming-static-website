## Output the complete link to the index.html file at hte end of the terraform build
output "Website_index_URL" {
  value = <<-EOT



  Link to the Website:
  https://${aws_cloudfront_distribution.static_website.domain_name}/index.html



EOT
  description = "This is the link to the index file of the website. Copy and paste it in your browser"
}
