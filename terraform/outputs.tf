output "web_instance_public_ip" {
  description = "Public IP of the web EC2 instance"
  value       = aws_instance.web.public_ip
}

output "web_instance_public_dns" {
  description = "Public DNS of the web EC2 instance"
  value       = aws_instance.web.public_dns
}

output "rds_endpoint" {
  description = "MySQL endpoint"
  value       = aws_db_instance.mysql.address
}

