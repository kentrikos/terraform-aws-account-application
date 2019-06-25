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
| azs | Availability Zones for the cluster (1 master per AZ will be deployed) | list | n/a | yes |
| enable\_default\_roles | Enable creation of default roles to assume | string | `"false"` | no |
| environment\_type | Type of environment (e.g. test, int, e2e, prod) | string | n/a | yes |
| iam\_cross\_account\_role\_arn | Cross-account role to assume before deploying the cluster | string | n/a | yes |
| k8s\_allowed\_worker\_nodeport\_cidrs | List of CIDR ranges allowed to connect to services exposed with NodePort in the cluster that are deployed by the module | list | `<list>` | no |
| k8s\_allowed\_worker\_ssh\_cidrs | List of CIDRs to allow SSH access into the cluster nodes | list | `<list>` | no |
| k8s\_aws\_ssh\_keypair\_name | Optional name of existing SSH keypair on AWS account, to be used for cluster instances (will be generated if not specified) | string | `""` | no |
| k8s\_enable\_cluster\_autoscaling | Enable cluster autoscaling (vertical/node scaling) | string | `"true"` | no |
| k8s\_enable\_pod\_autoscaling | Enable cluster horizontal pod autoscaling | string | `"true"` | no |
| k8s\_ingress\_deploy | Deploy Kubernetes Ingress controller on the cluster (requires install_helm=true) | string | `"true"` | no |
| k8s\_install\_helm | Install helm in the cluster | string | `"true"` | no |
| k8s\_linux\_distro | Linux distribution for K8s cluster instances (supported values: debian, amzn2) | string | `"debian"` | no |
| k8s\_master\_instance\_type | Instance type (size) for master nodes | string | `"m4.large"` | no |
| k8s\_masters\_iam\_policies\_arns | List of existing IAM policies that will be attached to instance profile for master nodes (EC2 instances) | list | n/a | yes |
| k8s\_node\_count | Number of worker nodes in Kubernetes cluster | string | `"1"` | no |
| k8s\_node\_instance\_type | Instance type (size) for worker nodes | string | `"m4.large"` | no |
| k8s\_nodes\_iam\_policies\_arns | List of existing IAM policies that will be attached to instance profile for worker nodes (EC2 instances) | list | n/a | yes |
| k8s\_private\_subnets | List of private subnets (matching AZs) where to deploy the cluster (required if existing VPC is used) | list | n/a | yes |
| k8s\_protect\_cluster\_from\_scale\_in | Protect the cluster from scale-in (Only valid if cluster autoscaling is enabled) | string | `"false"` | no |
| k8s\_public\_subnets | List of public subnets (matching AZs) where to deploy the cluster (required if existing VPC is used) | list | `<list>` | no |
| map\_accounts | Additional AWS account numbers to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format. | list | `<list>` | no |
| map\_accounts\_count | The count of accounts in the map_accounts list. | string | `"0"` | no |
| map\_roles | Additional IAM roles to add to the aws-auth configmap. See terraform-aws-modules-eks examples/basic/variables.tf for example format. | list | `<list>` | no |
| map\_roles\_count | The count of roles in the map_roles list. | string | `"0"` | no |
| map\_users | Additional IAM users to add to the aws-auth configmap. See terraform-aws-modules-eksexamples/basic/variables.tf for example format. | list | `<list>` | no |
| map\_users\_count | The count of roles in the map_users list. | string | `"0"` | no |
| new\_vpc\_cidr | CIDR range for VPC. | string | `""` | no |
| new\_vpc\_elastic\_ips | (Optional) A list of existing elastic ip addresses to assign to the VPC | list | `<list>` | no |
| new\_vpc\_private\_subnets | (Optional) A list of private subnets expressed in CIDR notation. This list size must match the list size of availability zones. | list | `<list>` | no |
| new\_vpc\_public\_subnets | (Optional) A list of public subnets expressed in CIDR notation. This list size must match the list size of availability zones. | list | `<list>` | no |
| product\_domain\_name | Name of product domain (e.g. maps) | string | n/a | yes |
| region | AWS region | string | n/a | yes |
| vpc\_id | ID of existing VPC where cluster will be deployed (if not specified new VPC will be created | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_certificate\_authority\_data | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. |
| cluster\_endpoint | Endpoint for EKS control plane. |
| cluster\_id | Name of the EKS cluster |
| cluster\_roles | Cluster roles to assueme for EKS |
| cluster\_security\_group\_id | Security group ID attached to the EKS cluster. |
| cluster\_version | The Kubernetes server version for the EKS cluster. |
| config\_map\_aws\_auth |  |
| ingress\_service\_nodeport\_http | Port number for ingress |
| kubeconfig | kubectl config as generated by the module. |
| worker\_iam\_role\_arn | default IAM role ARN for EKS worker groups |
| worker\_iam\_role\_name | default IAM role name for EKS worker groups |
| worker\_security\_group\_id | Security group ID attached to the EKS workers. |
| workers\_asg\_arns | IDs of the autoscaling groups containing workers. |
| workers\_asg\_names | Names of the autoscaling groups containing workers. |


