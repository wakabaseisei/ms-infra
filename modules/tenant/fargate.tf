# resource "aws_eks_fargate_profile" "fargate_profile" {
#     # Using one Fargate profile per subnet to ensure even Pod distribution and high availability.
#     # https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html
#     for_each = var.private_subnets
#     cluster_name           = var.cluster_name
#     fargate_profile_name   = "${var.namespace}-${each.value}"
#     pod_execution_role_arn = var.eks_fargate_pod_execution_role_arn
#     subnet_ids             = each.value

#     selector {
#         namespace = var.namespace
#     }
# }
