locals {
  cluster_name = "${var.region}-${var.product_domain_name}-${var.environment_type}"

  common_tags = {
    Terraform         = true
    ProductDomainName = var.product_domain_name
    EnvironmentType   = var.environment_type
    Cluster           = local.cluster_name
  }
}

# VPC for Kubernetes cluster:
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.7"

  create_vpc = var.vpc_id != "" ? false : true

  name = "${var.product_domain_name}-${var.environment_type}"

  reuse_nat_ips          = length(var.new_vpc_elastic_ips) == 0 ? false : true
  external_nat_ip_ids    = var.new_vpc_elastic_ips
  cidr                   = var.new_vpc_cidr
  azs                    = var.azs
  public_subnets         = var.new_vpc_public_subnets
  private_subnets        = var.new_vpc_private_subnets
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = local.common_tags
}

# Kubernetes cluster:
module "kubernetes_cluster_application" {
  source = "github.com/kentrikos/terraform-aws-eks?ref=managed_node_groups"

  cluster_prefix                = local.cluster_name
  region                        = var.region
  vpc_id                        = var.vpc_id != "" ? var.vpc_id : module.vpc.vpc_id
  private_subnets               = var.k8s_private_subnets
  public_subnets                = var.k8s_public_subnets
  desired_worker_nodes          = var.k8s_node_count
  worker_node_instance_type     = var.k8s_node_instance_type
  key_name                      = var.k8s_aws_ssh_keypair_name
  enable_cluster_autoscaling    = var.k8s_enable_cluster_autoscaling
  enable_pod_autoscaling        = var.k8s_enable_pod_autoscaling
  protect_cluster_from_scale_in = var.k8s_protect_cluster_from_scale_in
  install_helm                  = var.k8s_install_helm
  ingress_deploy                = var.k8s_ingress_deploy
  allowed_worker_ssh_cidrs      = var.k8s_allowed_worker_ssh_cidrs
  allowed_worker_nodeport_cidrs = var.k8s_allowed_worker_nodeport_cidrs

  cluster_version = var.k8s_cluster_version

  node_groups_defaults = var.node_groups_defaults
  node_groups          = var.node_groups

  map_roles            = var.map_roles
  map_users            = var.map_users
  map_accounts         = var.map_accounts
  enable_default_roles = var.enable_default_roles

  ingress_helm_values  = var.ingress_helm_values
  ingress_service_type = var.ingress_service_type

  cluster_enabled_log_types     = var.k8s_cluster_enabled_log_types
  cluster_log_retention_in_days = var.k8s_cluster_log_retention_in_days

  tags = local.common_tags
}

