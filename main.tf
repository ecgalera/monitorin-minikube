provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudformation_stack" "nginx_stack" {
  name          = "nginx-monitoring-stack"
  template_body = file("cloudformation-template.yml")

  parameters = {
    KeyName = var.KEY_NAME
  }
}

output "stack_id" {
  value = aws_cloudformation_stack.nginx_stack.id
}