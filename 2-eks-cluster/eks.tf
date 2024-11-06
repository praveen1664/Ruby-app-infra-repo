data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 3
    }
  ]
  write_kubeconfig   = true
  config_output_path = "./"
}
