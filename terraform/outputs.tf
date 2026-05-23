output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.suman_cluster.name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.suman_cluster.endpoint
}

output "region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "kubectl_command" {
  description = "Run this to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}
