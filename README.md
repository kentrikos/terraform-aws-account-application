# A Terraform module to create "application" type of environment.

This module will create an environment suitable for "application" type of AWS account.
Most important elements of the environment:

* VPC (module can create a new one or use existing one if vpc_id is passed as a parameter)
* Kubernetes cluster

# Notes

Terraform version  `>= 0.12`

# Usage

## Create new VPC:
* to be tested/improved

## Use existing VPC in application account:
```hcl
module "application" {                                                          
  source = "github.com/kentrikos/terraform-aws-account-application"

  product_domain_name              = "${var.product_domain_name}"
  environment_type                 = "${var.environment_type}"

  region                           = "${var.region}"
  azs                              = "${var.azs}"
  vpc_id                           = "${var.vpc_id}"
  k8s_private_subnets              = "${var.k8s_private_subnets}"
  k8s_public_subnets              = "${var.k8s_public_subnets}"

  k8s_node_count                   = "${var.k8s_node_count}"
  k8s_master_instance_type         = "${var.k8s_master_instance_type}"
  k8s_node_instance_type           = "${var.k8s_node_instance_type}"

  iam_cross_account_role_arn       = "${var.iam_cross_account_role_arn}"
  k8s_masters_iam_policies_arns    = "${var.k8s_masters_iam_policies_arns}"
  k8s_nodes_iam_policies_arns      = "${var.k8s_nodes_iam_policies_arns}"

  map_roles            = "${var.k8s_map_roles}"
  map_users            = "${var.k8s_map_users}"
  map_accounts         = "${var.k8s_map_accounts}"
  enable_default_roles = "${var.enable_default_roles}"
  
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `azs` | Availability Zones for the cluster (1 master per AZ will be deployed) | list(string) | n/a |  yes |
| `enable_default_roles` | Enable creation of default roles to assume | n/a | `true` |  no |
| `environment_type` | Type of environment (e.g. test, int, e2e, prod) | n/a | n/a |  yes |
| `iam_cross_account_role_arn` | Cross-account role to assume before deploying the cluster | n/a | n/a |  yes |
| `k8s_allowed_worker_nodeport_cidrs` | List of CIDR ranges allowed to connect to services exposed with NodePort in the cluster that are deployed by the module | list(string) | n/a |  yes |
| `k8s_allowed_worker_ssh_cidrs` | List of CIDRs to allow SSH access into the cluster nodes | list(string) | n/a |  yes |
| `k8s_aws_ssh_keypair_name` | Optional name of existing SSH keypair on AWS account, to be used for cluster instances (will be generated if not specified) | n/a | n/a |  yes |
| `k8s_enable_cluster_autoscaling` | Enable cluster autoscaling (vertical/node scaling) | n/a | `true` |  no |
| `k8s_enable_pod_autoscaling` | Enable cluster horizontal pod autoscaling | n/a | `true` |  no |
| `k8s_ingress_deploy` | Deploy Kubernetes Ingress controller on the cluster (requires install_helm=true) | n/a | `true` |  no |
| `k8s_install_helm` | Install helm in the cluster | n/a | `true` |  no |
| `k8s_linux_distro` | Linux distribution for K8s cluster instances (supported values: debian, amzn2) | n/a | `"debian"` |  no |
| `k8s_master_instance_type` | Instance type (size) for master nodes | n/a | `"m4.large"` |  no |
| `k8s_masters_iam_policies_arns` | List of existing IAM policies that will be attached to instance profile for master nodes (EC2 instances) | list(string) | n/a |  yes |
| `k8s_node_count` | Number of worker nodes in Kubernetes cluster | n/a | `"1"` |  no |
| `k8s_node_instance_type` | Instance type (size) for worker nodes | n/a | `"m4.large"` |  no |
| `k8s_nodes_iam_policies_arns` | List of existing IAM policies that will be attached to instance profile for worker nodes (EC2 instances) | list(string) | n/a |  yes |
| `k8s_private_subnets` | List of private subnets (matching AZs) where to deploy the cluster (required if existing VPC is used) | list(string) | n/a |  yes |
| `k8s_protect_cluster_from_scale_in` | Protect the cluster from scale-in (Only valid if cluster autoscaling is enabled) | n/a | n/a |  yes |
| `k8s_public_subnets` | List of public subnets (matching AZs) where to deploy the cluster (required if existing VPC is used) | list(string) | n/a |  yes |
| `map_accounts` | Additional AWS account numbers to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format. | list(string) | n/a |  yes |
| `map_roles` | Additional IAM roles to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format. | list(map(string)) | n/a |  yes |
| `map_users` | Additional IAM users to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format. | list(map(string)) | n/a |  yes |
| `new_vpc_cidr` | CIDR range for VPC. | n/a | n/a |  yes |
| `new_vpc_elastic_ips` | (Optional) A list of existing elastic ip addresses to assign to the VPC | list(string) | n/a |  yes |
| `new_vpc_private_subnets` | (Optional) A list of private subnets expressed in CIDR notation. This list size must match the list size of availability zones. | list(string) | n/a |  yes |
| `new_vpc_public_subnets` | (Optional) A list of public subnets expressed in CIDR notation. This list size must match the list size of availability zones. | list(string) | n/a |  yes |
| `product_domain_name` | Name of product domain (e.g. maps) | n/a | n/a |  yes |
| `region` | AWS region | n/a | n/a |  yes |
| `vpc_id` | ID of existing VPC where cluster will be deployed (if not specified new VPC will be created | n/a | n/a |  yes |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_certificate_authority_data` | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. |
| `cluster_endpoint` | Endpoint for EKS control plane. |
| `cluster_id` | Name of the EKS cluster |
| `cluster_roles` | Cluster roles to assueme for EKS |
| `cluster_security_group_id` | Security group ID attached to the EKS cluster. |
| `cluster_version` | The Kubernetes server version for the EKS cluster. |
| `config_map_aws_auth` | n/a |
| `ingress_service_nodeport_http` | Port number for ingress |
| `kubeconfig` | kubectl config as generated by the module. |
| `worker_iam_role_arn` | default IAM role ARN for EKS worker groups |
| `worker_iam_role_name` | default IAM role name for EKS worker groups |
| `worker_security_group_id` | Security group ID attached to the EKS workers. |
| `workers_asg_arns` | IDs of the autoscaling groups containing workers. |
| `workers_asg_names` | Names of the autoscaling groups containing workers. |



