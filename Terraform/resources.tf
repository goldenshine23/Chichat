
resource "aws_instance" "my_ec2" {
  ami           = "ami-051fd0ca694aa2379" # Replace with your region-specific AMI
  instance_type = "t2.micro"

  tags = {
    Name = "chichat"
  }
}
resource "aws_iam_role" "chichat_cluster_role" {
  name = "chichat-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}