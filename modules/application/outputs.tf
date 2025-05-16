output "irsa_role_name" {
    value = length(aws_iam_role.irsa) > 0 ? aws_iam_role.irsa[0].name : null
}
