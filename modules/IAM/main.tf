resource "aws_iam_role" "eks_cluster_iam_role" {
    name = "${var.project_name}-EKS-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "eks.amazonaws.com"
                }    
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_iam_role.name
}

resource "aws_iam_role_policy_attachment" "elb-fullaccess" {
    policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    role = aws_iam_role.eks_cluster_iam_role.name
}


resource "aws_iam_role" "node-group" {
    name = "${var.project_name}-NodeGroup-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }    
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy_attachment" "eks-cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy_attachment" "ECR-read" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node-group.name
}
