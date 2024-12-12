output "eks_fargate_pod_execution_role_arn" {
  value = aws_iam_role.eks-fargate-pod-execution-role.arn
}