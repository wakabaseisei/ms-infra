variable "account_id" {
  type = string
}

variable "cluster_identifier" {
  type = string
  description = "RDS cluster ID"
}

variable "cluster_vpc_id" {
  type = string
  description = "The ID of the VPC where the RDS cluster will be deployed."
}

variable "cluster_instances_subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs where the RDS instances can be deployed."
}

variable "cluster_ingress_allowed_security_groups" {
  type        = list(string)
  description = "List of Security Group IDs allowed to access the RDS cluster."
}

variable "engine" {
  type = string
  description = "Name of the database engine"
  default = "aurora-mysql"
  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql", "mysql", "postgres"], var.engine)
    error_message = "Allowed values for engine are \"aurora-mysql\", \"aurora-postgresql\", \"mysql\", or \"postgres\"."
  }
}

variable "engine_version" {
  type = string
  description = "Database engine version"
  default = "8.0.mysql_aurora.3.08.0"
}


variable "engine_mode" {
  type = string
  description = "Database engine mode."
  default = "provisioned"
  validation {
    condition     = contains(["global", "parallelquery", "provisioned", "serverless"], var.engine_mode)
    error_message = "Allowed values for engine_mode are \"global\", \"parallelquery\", \"provisioned\", or \"serverless\"."
  }
}

variable "database_name" {
  type = string
  description = "Name for an automatically created database on cluster creation"
}

variable "master_username" {
  type = string
  description = "Username for the master DB user."
  default = "admin"
}

variable "writer_instance_class_type" {
  type = string
  description = "Writer instance class"
  default = "db.serverless"
}

variable "reader_instance_classes" {
  type = list(string)
  description = "Reader instance classes"
  default = null
}

variable "serverlessv2_scaling_configuration" {
  type = object({
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = number
  })
  
  default = {
    max_capacity = 1.0
    min_capacity = 0.0
    seconds_until_auto_pause = 600
  }
}

variable "database_username" {
  type = string
  description = "To use for Application or Migration"
}

variable "database_access_client" {
  type = object({
    role = string
    security_group_id = string

  })
  default = null
}

variable "migration_lambda" {
  type = object({
    image_url = string
    image_tag = string
    entry_point = set(string)
  })

  default = null
}
