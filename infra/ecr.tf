resource "aws_ecr_repository" "services" {
  name = "services"

  image_scanning_configuration {
    scan_on_push = false
  }

  lifecycle {
    prevent_destroy = true
  }
}