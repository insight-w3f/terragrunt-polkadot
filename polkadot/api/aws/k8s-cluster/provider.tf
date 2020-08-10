data "aws_eks_cluster" "cluster" {
  name = join("", aws_eks_cluster.this.*.id)
//  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  //  name = var.cluster_name
  name = join("", aws_eks_cluster.this.*.id)
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
  load_config_file = false
}