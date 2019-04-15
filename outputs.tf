output "cluster_id" {
  value = "${module.kubernetes_cluster_application.cluster_id}"
}

output "worker_iam_role_name" {
  value = "${module.kubernetes_cluster_application.worker_iam_role_name}"
}
