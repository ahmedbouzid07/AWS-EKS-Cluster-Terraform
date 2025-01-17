resource "aws_eks_cluster" "eks-cluster" {
  name = "${var.project_name}-EKS-Cluster"
  access_config {
    authentication_mode = "API"
  }
  role_arn = var.eks-cluster-role-arn
  vpc_config {
    subnet_ids = [
      var.pub-sub1-id,
      var.pub-sub2-id,
      var.prv-sub1-id,
      var.prv-sub2-id
    ]
  }

  depends_on = [var.cluster_AmazoneEKSClusterPolicy]
}
