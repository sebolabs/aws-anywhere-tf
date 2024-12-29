# GENERAL
variable "aws_region" {
  type        = string
  description = "The AWS Region"
}

variable "project" {
  type        = string
  description = "The Project name"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "component" {
  type        = string
  description = "The TF component name"
  default     = "aws-anywhere"
}

variable "tf_state_bucket_name_prefix" {
  type        = string
  description = "Terraform state bucket name prefix"
}

variable "aws_account_id" {
  type        = string
  description = "The allowed AWS account ID to prevent you from mistakenly using an incorrect one"
}

variable "additional_default_tags" {
  type        = map(string)
  description = "A map with additional default tags to be applied at the AWS provider level"
  default     = {}
}

# SPECIFIC
variable "transit_vpc_cidrs" {
  type = object({
    vpc             = string
    public_subnets  = list(string)
    private_subnets = list(string)
    intra_subnets   = list(string)
  })
  description = "A map with Transit VPC and subnets CIDR blocks"
}

variable "cw_logs_retention_days" {
  type        = number
  description = "The number of days any CloudWatch logs should be retained"
  default     = 3
}

variable "vpc_flow_logs_s3_bucket_arn" {
  type        = string
  description = "The ARN of a dedicated S3 bucket for storing logs. If not provided CW LG will be configured instead"
  default     = null
}

variable "on_prem_s2s_vpn_enabled" {
  type        = bool
  description = "Whther the Site-to-Site VPN connection to on-prem is enabled"
  default     = false
}

variable "on_prem_props" {
  type = object({
    bgp_asn           = optional(number)
    public_ip_address = optional(string)
    private_cidr      = optional(string)
    vpn_host_ip       = optional(string)
  })
  description = "A map with on-prem relevant properties"
  sensitive   = true
  default     = {}
}

variable "generate_strongswan_vpn_guide_md" {
  type        = bool
  description = "Whether to generate the Strongswan VPN Guide as a local file"
  default     = true
}

variable "r53_inbound_resolver_enabled" {
  type        = bool
  description = "Whther the Route53 Inbound Resolver for on-prem is enabled"
  default     = false
}

variable "generate_bind_dns_guide_md" {
  type        = bool
  description = "Whether to generate the Bind DNS Guide as a local file"
  default     = true
}

variable "iam_roles_anywhere_enabled" {
  type        = bool
  description = "Whether IAM roles anywhere should be configured"
  default     = false
}

variable "generate_rolesanywhere_ca_guide_md" {
  type        = bool
  description = "Whether to generate the CA RolesAnywhere Guide as a local file"
  default     = true
}

variable "ssm_hybrid_activation_registred" {
  type        = bool
  description = "Whether the SSM hybrid activation is registered (manually)."
  default     = false
}

variable "ssm_advanced_instances_tier_enabled" {
  type        = bool
  description = "Whether the SSM advanced-instances tier is enabled."
  default     = false
}

variable "generate_ssm_agent_guide_md" {
  type        = bool
  description = "Whether to generate the SSM Agent Guide as a local file"
  default     = true
}

variable "eks_hybrid_nodes_enabled" {
  type        = bool
  description = "Whether EKS Hybrid Nodes should be configured"
  default     = false
}

variable "eks_props" {
  type = object({
    cluster_name    = optional(string)
    cluster_version = optional(string)
    vpc_name        = optional(string)
    vpc_id          = optional(string)
    vpc_cidr        = optional(string)
    tgw_subnet_ids  = optional(list(string))
  })
  description = "A map with EKS relevant properties"
  default     = {}
}

variable "generate_eks_hybrid_nodes_guide_md" {
  type        = bool
  description = "Whether to generate the EKS Hybrid Nodes Guide as a local file"
  default     = true
}
