variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "suman-devops-cluster"
}

variable "node_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 2
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "suman-devops"
}
