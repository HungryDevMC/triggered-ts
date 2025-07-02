resource "aws_ecr_repository" "services" {
  name = "teamspeak"

  image_scanning_configuration {
    scan_on_push = false
  }

  lifecycle {
    prevent_destroy = true
  }
}

# ECR lifecycle policy to reduce storage costs
resource "aws_ecr_lifecycle_policy" "teamspeak_lifecycle" {
  repository = aws_ecr_repository.services.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}