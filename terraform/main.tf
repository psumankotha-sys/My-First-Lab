# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

#--------------------------
# VPC
#--------------------------
resource "aws_vpc" "suman_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

#--------------------------
# Public Subnets
#--------------------------
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.suman_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-subnet-${count.index + 1}"
    Project                  = var.project_name
    "kubernetes.io/role/elb" = "1"
  }
}

#--------------------------
# Internet Gateway
#--------------------------
resource "aws_internet_gateway" "suman_igw" {
  vpc_id = aws_vpc.suman_vpc.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

#--------------------------
# Route Table
#--------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.suman_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.suman_igw.id
  }

  tags = {
    Name    = "${var.project_name}-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

#--------------------------
# IAM Role - EKS Cluster
#--------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

#--------------------------
# EKS Cluster
#--------------------------
resource "aws_eks_cluster" "suman_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = aws_subnet.public_subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name    = var.cluster_name
    Project = var.project_name
  }
}

#--------------------------
# IAM Role - Node Group
#--------------------------
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

#--------------------------
# Node Group
#--------------------------
resource "aws_eks_node_group" "suman_nodes" {
  cluster_name    = aws_eks_cluster.suman_cluster.name
  node_group_name = "suman-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.public_subnet[*].id
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = var.node_count
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_registry_policy
  ]

  tags = {
    Name    = "${var.project_name}-nodes"
    Project = var.project_name
  }
}

# S3 Bucket for DevOps artifacts
resource "aws_s3_bucket" "suman_bucket" {
  bucket = "suman-devops-artifacts-${random_id.bucket_id.hex}"

  tags = {
    Name    = "suman-devops-bucket"
    Project = var.project_name
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}