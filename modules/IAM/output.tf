output "eks-cluster-role-arn" {
    value = aws_iam_role.eks_cluster_iam_role.arn
}

output "cluster_AmazoneEKSClusterPolicy" {
    value = aws_iam_role_policy_attachment.eks-cluster-policy
}

output "node_role_arn" {
  value = aws_iam_role.node-group.arn
}