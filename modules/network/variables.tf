variable "name" {
  description = "A name prefix to be used for all resources created by this module, providing a common identifier."
  type        = string
}

variable "azs" {
  type        = list(string)
  description = "A list of Availability Zones where subnets will be created. The order determines the AZ for each subnet in the lists."
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of CIDR blocks for the public subnets to be created within the VPC."
}

variable "public_subnet_tags" {
  description = "Additional tags to apply to the public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of CIDR blocks for the private subnets to be created within the VPC."
}

variable "private_subnet_tags" {
  description = "Additional tags to apply to the private subnets."
  type        = map(string)
  default     = {}
}

variable "database_subnets" {
  type        = list(string)
  description = "A list of CIDR blocks for the database subnets to be created within the VPC."
}

variable "database_subnets_tags" {
  description = "Additional tags to apply to the database subnets."
  type        = map(string)
  default     = {}
}

variable "enable_nat_gateway" {
  description = "A boolean flag to determine if NAT Gateways should be provisioned for each private subnet, allowing outbound internet access."
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "A boolean flag to provision only one NAT Gateway per Availability Zone. Requires `var.azs` to be set and the number of public subnets to be greater than or equal to the number of AZs."
  type        = bool
  default     = false
}
