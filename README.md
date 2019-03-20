# A Terraform module to create "application" type of environment.

This module will create an environment suitable for "application" type of AWS account.
Most important elements of the environment:

* VPC (module can create a new one or use existing one if vpc_id is passed as a parameter)
* Kubernetes cluster

# Notes

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

}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | Availability Zones for the cluster (1 master per AZ will be deployed) | list | - | yes |
| environment_type | Type of environment (e.g. test, int, e2e, prod) | string | - | yes |
| iam_cross_account_role_arn | Cross-account role to assume before deploying the cluster | string | - | yes |
| k8s_allowed_worker_ssh_cidrs | List of CIDRs to allow SSH access into the cluster nodes | list | `<list>` | no |
| k8s_aws_ssh_keypair_name | Optional name of existing SSH keypair on AWS account, to be used for cluster instances (will be generated if not specified) | string | `` | no |
| k8s_enable_cluster_autoscaling | Enable cluster autoscaling (vertical/node scaling) | string | `true` | no |
| k8s_enable_pod_autoscaling | Enable cluster horizontal pod autoscaling | string | `true` | no |
| k8s_install_helm | Install helm in the cluster | string | `true` | no |
| k8s_linux_distro | Linux distribution for K8s cluster instances (supported values: debian, amzn2) | string | `debian` | no |
| k8s_master_instance_type | Instance type (size) for master nodes | string | `m4.large` | no |
| k8s_masters_iam_policies_arns | List of existing IAM policies that will be attached to instance profile for master nodes (EC2 instances) | list | - | yes |
| k8s_node_count | Number of worker nodes in Kubernetes cluster | string | `1` | no |
| k8s_node_instance_type | Instance type (size) for worker nodes | string | `m4.large` | no |
| k8s_nodes_iam_policies_arns | List of existing IAM policies that will be attached to instance profile for worker nodes (EC2 instances) | list | - | yes |
| k8s_private_subnets | List of private subnets (matching AZs) where to deploy the cluster (required if existing VPC is used) | list | - | yes |
| k8s_protect_cluster_from_scale_in | Protect the cluster from scale-in (Only valid if cluster autoscaling is enabled) | string | `false` | no |
| k8s_public_subnets | List of public subnets (matching AZs) where to deploy the cluster (required if existing VPC is used) | list | `<list>` | no |
| new_vpc_cidr | CIDR range for VPC. | string | `` | no |
| new_vpc_elastic_ips | (Optional) A list of existing elastic ip addresses to assign to the VPC | list | `<list>` | no |
| new_vpc_private_subnets | (Optional) A list of private subnets expressed in CIDR notation. This list size must match the list size of availability zones. | list | `<list>` | no |
| new_vpc_public_subnets | (Optional) A list of public subnets expressed in CIDR notation. This list size must match the list size of availability zones. | list | `<list>` | no |
| product_domain_name | Name of product domain (e.g. maps) | string | - | yes |
| region | AWS region | string | - | yes |
| vpc_id | ID of existing VPC where cluster will be deployed (if not specified new VPC will be created | string | - | yes |
