variable "product_domain_name" {
  description = "Name of product domain (e.g. maps)"
}

variable "environment_type" {
  description = "Type of environment (e.g. test, int, e2e, prod)"
}

variable "vpc_id" {
  description = "ID of existing VPC where cluster will be deployed (if not specified new VPC will be created"
}

variable "new_vpc_cidr" {
  description = "CIDR range for VPC."
  default     = ""
}

variable "new_vpc_private_subnets" {
  description = "(Optional) A list of private subnets expressed in CIDR notation. This list size must match the list size of availability zones."
  type        = list(string)
  default     = []
}

variable "new_vpc_public_subnets" {
  description = "(Optional) A list of public subnets expressed in CIDR notation. This list size must match the list size of availability zones."
  type        = list(string)
  default     = []
}

variable "new_vpc_elastic_ips" {
  description = "(Optional) A list of existing elastic ip addresses to assign to the VPC"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "AWS region"
}

variable "azs" {
  description = "Availability Zones for the cluster (1 master per AZ will be deployed)"
  type        = list(string)
}

variable "k8s_private_subnets" {
  description = "List of private subnets (matching AZs) where to deploy the cluster (required if existing VPC is used)"
  type        = list(string)
}

variable "k8s_public_subnets" {
  description = "List of public subnets (matching AZs) where to deploy the cluster (required if existing VPC is used)"
  type        = list(string)
  default     = []
}

variable "k8s_node_count" {
  description = "Number of worker nodes in Kubernetes cluster"
  default     = "1"
}

variable "k8s_master_instance_type" {
  description = "Instance type (size) for master nodes"
  default     = "m4.large"
}

variable "k8s_node_instance_type" {
  description = "Instance type (size) for worker nodes"
  default     = "m4.large"
}

variable "iam_cross_account_role_arn" {
  description = "Cross-account role to assume before deploying the cluster"
}

variable "k8s_masters_iam_policies_arns" {
  description = "List of existing IAM policies that will be attached to instance profile for master nodes (EC2 instances)"
  type        = list(string)
}

variable "k8s_nodes_iam_policies_arns" {
  description = "List of existing IAM policies that will be attached to instance profile for worker nodes (EC2 instances)"
  type        = list(string)
}

variable "k8s_aws_ssh_keypair_name" {
  description = "Optional name of existing SSH keypair on AWS account, to be used for cluster instances (will be generated if not specified)"
  default     = ""
}

variable "k8s_linux_distro" {
  description = "Linux distribution for K8s cluster instances (supported values: debian, amzn2)"
  default     = "debian"
}

variable "k8s_enable_cluster_autoscaling" {
  description = "Enable cluster autoscaling (vertical/node scaling)"
  default     = true
}

variable "k8s_enable_pod_autoscaling" {
  description = "Enable cluster horizontal pod autoscaling"
  default     = true
}

variable "k8s_protect_cluster_from_scale_in" {
  description = "Protect the cluster from scale-in (Only valid if cluster autoscaling is enabled)"
  default     = false
}

variable "k8s_install_helm" {
  description = "Install helm in the cluster"
  default     = true
}

variable "k8s_ingress_deploy" {
  description = "Deploy Kubernetes Ingress controller on the cluster (requires install_helm=true)"
  default     = true
}

variable "k8s_allowed_worker_ssh_cidrs" {
  description = "List of CIDRs to allow SSH access into the cluster nodes"
  type        = list(string)
  default     = []
}

variable "k8s_allowed_worker_nodeport_cidrs" {
  description = "List of CIDR ranges allowed to connect to services exposed with NodePort in the cluster that are deployed by the module"
  type        = list(string)
  default     = []
}

variable "k8s_cluster_version" {
  type        = string
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.13"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format."
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "enable_default_roles" {
  description = "Enable creation of default roles to assume"
  default     = true
}

variable "ingress_helm_values" {
  default     = {}
  description = "For helm ingress chart values in k => v map"
}

variable "ingress_service_type" {
  description = "Type of ingress controller service to create"
  default     = "NodePort"
}

variable "k8s_cluster_enabled_log_types" {
  default     = []
  description = "A list of the desired control plane logging to enable. [api,audit,authenticator,controllerManager,scheduler] For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}

variable "k8s_cluster_log_retention_in_days" {
  default     = 90
  description = "Number of days to retain log events. Default retention - 90 days."
  type        = number
}

variable "node_groups_defaults" {
  description = "map of maps of node groups to create."
  type        = any
}

variable "node_groups" {
  description = "Map of maps of `eks_node_groups` to create."
  type        = any
  default     = {}
}