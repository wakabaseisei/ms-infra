variable "cluster_identifier" {
  type        = string
  description = "The unique identifier for the RDS cluster. This name is also used in other related resource names."
}

variable "cluster_vpc_id" {
  type        = string
  description = "The ID of the VPC where the RDS cluster and its associated resources will be deployed."
}

variable "engine" {
  type        = string
  description = "The name of the database engine to use for the RDS cluster. Allowed values are \"aurora-mysql\", \"aurora-postgresql\", \"mysql\", or \"postgres\"."
  default     = "aurora-mysql"
  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql", "mysql", "postgres"], var.engine)
    error_message = "Allowed values for engine are \"aurora-mysql\", \"aurora-postgresql\", \"mysql\", or \"postgres\"."
  }
}

variable "engine_version" {
  type        = string
  description = "The version of the database engine to use for the RDS cluster. The default value is specific to Aurora MySQL."
  default     = "8.0.mysql_aurora.3.08.0"
}

variable "engine_mode" {
  type        = string
  description = "The database engine mode for the RDS cluster. Allowed values are \"global\", \"parallelquery\", \"provisioned\", or \"serverless\"."
  default     = "provisioned"
  validation {
    condition     = contains(["global", "parallelquery", "provisioned", "serverless"], var.engine_mode)
    error_message = "Allowed values for engine_mode are \"global\", \"parallelquery\", \"provisioned\", or \"serverless\"."
  }
}

variable "cluster_instances_subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs where the RDS cluster instances (writer and readers) can be deployed. Ensure these subnets are within the specified VPC."
}

variable "writer_instance_class_type" {
  type        = string
  description = "The instance class to use for the writer node of the RDS cluster. For serverless v2, use 'db.serverless'."
  default     = "db.serverless"
}

variable "reader_instances" {
  type = list(object({
    instance_class = string
    promotion_tier = number
  }))

  description = <<-EOT
    List of reader DB instances with promotion tiers.
    • Tiers 0 and 1: Always maintain at least the same capacity as the writer instance.
    • Tiers 2 through 15: Scale independently from the writer.
    ref:
      - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.how-it-works.html#aurora-serverless-v2.how-it-works.scaling
      - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2-administration.html#aurora-serverless-v2-choosing-promotion-tier
  EOT

  validation {
    condition     = alltrue([for inst in var.reader_instances : inst.promotion_tier >= 0 && inst.promotion_tier <= 15])
    error_message = "promotion_tier must be an integer between 0 and 15."
  }

  default = []
}


variable "serverlessv2_scaling_configuration" {
  type = object({
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = optional(number)
  })
  
  description = <<-EOT
    Configuration for Aurora Serverless v2 scaling.
    Only applicable when engine_mode is 'provisioned'.
    seconds_until_auto_pause: The number of seconds until the cluster automatically pauses if it has been idle for that duration.
    If min_capacity is 0, seconds_until_auto_pause must be 300-86400.
    ref:
      - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.setting-capacity.html
      - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2-auto-pause.html#auto-pause-how-it-works
  EOT

  default = {
    max_capacity             = 1.0
    min_capacity             = 0.0
    seconds_until_auto_pause = 600
  }
}

variable "master_username" {
  type        = string
  description = "The username for the master database user for the RDS cluster."
  default     = "admin"
}

variable "database_name" {
  type        = string
  description = "The name of the initial database to create when the RDS cluster is first provisioned."
}

variable "database_username" {
  type        = string
  description = "The username to create in the database for application or migration access."
}

variable "database_access_client" {
  type = object({
    role              = string
    security_group_id = string
  })
  description = "Optional configuration for granting database access to a specific client. Requires the client's IAM role ARN and security group ID."
  default     = null
}

variable "migration_lambda" {
  type = object({
    image_url   = string
    image_tag   = string
    entry_point = set(string)
  })
  description = "Optional configuration for a Lambda function to run database migrations. Requires the container image URL, tag, and entry point."
  default     = null
}
