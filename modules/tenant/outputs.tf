output "irsa_role_name" {
    value = aws_iam_role.irsa[0].name
}
