resource "aws_ecr_repository" "chichat_repo" {
  name                 = "chichat"  # e.g. "chichat-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "chichat"
  }
}