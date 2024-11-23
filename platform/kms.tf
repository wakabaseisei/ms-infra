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
