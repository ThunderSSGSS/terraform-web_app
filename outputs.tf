output "web_app_url" {
    value = "http://${aws_lb.web_app.dns_name}"
}