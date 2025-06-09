resource "aws_ecr_repository" "chichat_repo" {
  name                 = "chichat"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "chichat"
  }
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.chichat_repo.repository_url
  description = "The URI of the chichat ECR repository"
}
