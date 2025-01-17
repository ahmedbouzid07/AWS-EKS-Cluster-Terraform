resource "aws_eks_node_group" "nodeGroup" {
  cluster_name = var.cluster_name
  node_group_name = "${var.cluster_name}-Cluster-Node-Group"

  node_role_arn = var.node_role_arn
  subnet_ids = [
    var.prv-sub1-id,
    var.prv-sub2-id
  ]

  scaling_config {
    desired_size = 2
    max_size = 2
    min_size = 2
  }

  ami_type = "AL2_x86_64"

  capacity_type = "ON_DEMAND"

  disk_size = 20

  force_update_version = false

  instance_types = [ "t2.micro" ]

  labels = {
    role = "${var.cluster_name}-Node-group-role"
    name = "${var.cluster_name}-Cluster-Node-Group"
  }
}