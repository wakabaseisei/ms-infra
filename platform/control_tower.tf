resource "aws_iam_role" "controltower_admin" {
  name = "AWSControlTowerAdmin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "controltower.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "controltower_admin_managed" {
  role       = aws_iam_role.controltower_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerServiceRolePolicy"
}

resource "aws_iam_policy" "controltower_admin" {
  name = "AWSControlTowerAdminPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ec2:DescribeAvailabilityZones"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_admin_custom" {
  role       = aws_iam_role.controltower_admin.name
  policy_arn = aws_iam_policy.controltower_admin.arn
}

resource "aws_iam_role" "controltower_cloudtrail" {
  name = "AWSControlTowerCloudTrailRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_policy" "controltower_cloudtrail" {
  name = "AWSControlTowerCloudTrailRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "arn:aws:logs:*:*:log-group:aws-controltower/CloudTrailLogs:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_cloudtrail" {
  role       = aws_iam_role.controltower_cloudtrail.name
  policy_arn = aws_iam_policy.controltower_cloudtrail.arn
}

resource "aws_iam_role" "controltower_config" {
  name = "AWSControlTowerConfigAggregatorRoleForOrganizations"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "controltower_config" {
  role       = aws_iam_role.controltower_config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_iam_role" "controltower_stackset" {
  name = "AWSControlTowerStackSetRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudformation.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_policy" "controltower_stackset" {
  name = "AWSControlTowerStackSetRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::*:role/AWSControlTowerExecution"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_stackset" {
  role       = aws_iam_role.controltower_stackset.name
  policy_arn = aws_iam_policy.controltower_stackset.arn
}

resource "aws_kms_key" "control_tower_kms_key" {
  description             = "The AWS Key used in AWS Control Tower for encryption and decryption in the landing zone"
  enable_key_rotation     = true
  deletion_window_in_days = 20

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "key-default-1"
    Statement = [
      {
        Sid       = "Allow Config to use KMS for encryption"
        Effect    = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Sid       = "Allow CloudTrail to use KMS for encryption"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/aws-controltower-BaselineCloudTrail"
          }
          StringLike = {
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
          }
        }
      },
      {
        Sid       = "Enable IAM User Permissions"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
    ]
  })
}

resource "aws_kms_alias" "control_tower_custom_kms_alias" {
  name          = "alias/ct-kms-key"
  target_key_id = aws_kms_key.control_tower_kms_key.key_id
}

# TODO: To optimize costs, we will apply this change at a later, carefully chosen time.
# resource "aws_controltower_landing_zone" "main" {
#   manifest_json = jsonencode(
#     {
#       "governedRegions" : [
#         "${data.aws_region.current.name}",
#       ],
#       "organizationStructure" : {
#         "security" : {
#           "name" : "Security"
#         },
#         "sandbox" : {
#           "name" : "Sandbox"
#         }
#       },
#       "centralizedLogging" : {
#         "accountId" : "${aws_organizations_account.log_archive.id}",
#         "configurations" : {
#           "loggingBucket" : {
#             "retentionDays" : 2
#           },
#           "accessLoggingBucket" : {
#             "retentionDays" : 2
#           }
#           "kmsKeyArn": "${aws_kms_key.control_tower_kms_key.arn}"
#         },
#         "enabled" : true
#       },
#       "securityRoles" : {
#         "accountId" : "${aws_organizations_account.audit.id}"
#       },
#       "accessManagement" : {
#         "enabled" : false
#       }
#     }
#   )
#   version = "3.3"
# }
