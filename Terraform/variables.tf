# variables.tf
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-051fd0ca694aa2379"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name for EC2 instance"
  type        = string
  default     = "chichat"
}