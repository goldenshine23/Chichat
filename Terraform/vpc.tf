# main.tf (or ekscluster.tf)

# VPC
resource "aws_vpc" "Chichat" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "chichat-vpc" }
}

# Subnets
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.Chichat.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags              = { Name = "chichat-public-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.Chichat.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags              = { Name = "chichat-public-2" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Chichat.id
  tags   = { Name = "chichat-igw" }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Chichat.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "chichat-public-rt" }
}

# Route Table Associations
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "chichat_node_role" {
  name = "chichat-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policies to IAM Role
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.chichat_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.chichat_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "registry_policy" {
  role       = aws_iam_role.chichat_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Instance Profile for Worker Nodes
resource "aws_iam_instance_profile" "chichat_node_profile" {
  name = "chichat-node-profile"
  role = aws_iam_role.chichat_node_role.name
}

# Launch Template for Worker Nodes using variables
resource "aws_launch_template" "chichat_node_lt" {
  name_prefix   = "chichat-node-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.chichat_node_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.public_1.id
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.instance_name
    }
  }
}

# EKS Cluster (simplified)
resource "aws_eks_cluster" "chichat_cluster" {
  name     = "chichat-cluster"
  role_arn = aws_iam_role.chichat_node_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id
    ]
  }
}