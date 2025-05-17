output "irsa_role_name" {
  value       = length(aws_iam_role.irsa) > 0 ? aws_iam_role.irsa[0].name : null
  description = "The name of the IAM role created for IRSA (IAM Roles for Service Accounts). Returns null if IRSA is disabled."
}
