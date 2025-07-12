<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.rds_iam_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.secretsmanager_get_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.db_user_generator_lambda_invoke_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_migration_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.get_secret_to_db_gen_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_access_execution_role_to_db_gen_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_access_execution_role_to_migration_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.rds_iam_auth_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.rds_iam_auth_attach_to_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.db_user_generator_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.migration_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_rds_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_security_group.lambda_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_cluster_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.lambda_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_database_access_client_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_lambda_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [terraform_data.db_user_generator_lambda_invoke](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.rds_iam_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The unique identifier for the RDS cluster. This name is also used in other related resource names. | `string` | n/a | yes |
| <a name="input_cluster_instances_subnet_ids"></a> [cluster\_instances\_subnet\_ids](#input\_cluster\_instances\_subnet\_ids) | A list of VPC subnet IDs where the RDS cluster instances (writer and readers) can be deployed. Ensure these subnets are within the specified VPC. | `list(string)` | n/a | yes |
| <a name="input_cluster_vpc_id"></a> [cluster\_vpc\_id](#input\_cluster\_vpc\_id) | The ID of the VPC where the RDS cluster and its associated resources will be deployed. | `string` | n/a | yes |
| <a name="input_database_access_client"></a> [database\_access\_client](#input\_database\_access\_client) | Optional configuration for granting database access to a specific client. Requires the client's IAM role ARN and security group ID. | <pre>object({<br/>    role              = string<br/>    security_group_id = string<br/>  })</pre> | `null` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the initial database to create when the RDS cluster is first provisioned. | `string` | n/a | yes |
| <a name="input_database_username"></a> [database\_username](#input\_database\_username) | The username to create in the database for application or migration access. | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the database engine to use for the RDS cluster. Allowed values are "aurora-mysql", "aurora-postgresql", "mysql", or "postgres". | `string` | `"aurora-mysql"` | no |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | The database engine mode for the RDS cluster. Allowed values are "global", "parallelquery", "provisioned", or "serverless". | `string` | `"provisioned"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version of the database engine to use for the RDS cluster. The default value is specific to Aurora MySQL. | `string` | `"8.0.mysql_aurora.3.08.0"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | The username for the master database user for the RDS cluster. | `string` | `"admin"` | no |
| <a name="input_migration_lambda"></a> [migration\_lambda](#input\_migration\_lambda) | Optional configuration for a Lambda function to run database migrations. Requires the container image URL, tag, and entry point. | <pre>object({<br/>    image_url   = string<br/>    image_tag   = string<br/>    entry_point = set(string)<br/>  })</pre> | `null` | no |
| <a name="input_reader_instances"></a> [reader\_instances](#input\_reader\_instances) | List of reader DB instances with promotion tiers.<br/>• Tiers 0 and 1: Always maintain at least the same capacity as the writer instance.<br/>• Tiers 2 through 15: Scale independently from the writer.<br/>ref:<br/>  - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.how-it-works.html#aurora-serverless-v2.how-it-works.scaling<br/>  - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2-administration.html#aurora-serverless-v2-choosing-promotion-tier | <pre>list(object({<br/>    instance_class = string<br/>    promotion_tier = number<br/>  }))</pre> | `[]` | no |
| <a name="input_serverlessv2_scaling_configuration"></a> [serverlessv2\_scaling\_configuration](#input\_serverlessv2\_scaling\_configuration) | Configuration for Aurora Serverless v2 scaling.<br/>Only applicable when engine\_mode is 'provisioned'.<br/>seconds\_until\_auto\_pause: The number of seconds until the cluster automatically pauses if it has been idle for that duration.<br/>If min\_capacity is 0, seconds\_until\_auto\_pause must be 300-86400.<br/>ref:<br/>  - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.setting-capacity.html<br/>  - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2-auto-pause.html#auto-pause-how-it-works | <pre>object({<br/>    max_capacity             = number<br/>    min_capacity             = number<br/>    seconds_until_auto_pause = optional(number)<br/>  })</pre> | <pre>{<br/>  "max_capacity": 1,<br/>  "min_capacity": 0,<br/>  "seconds_until_auto_pause": 600<br/>}</pre> | no |
| <a name="input_writer_instance_class_type"></a> [writer\_instance\_class\_type](#input\_writer\_instance\_class\_type) | The instance class to use for the writer node of the RDS cluster. For serverless v2, use 'db.serverless'. | `string` | `"db.serverless"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->