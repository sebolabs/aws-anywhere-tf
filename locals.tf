locals {
  # GENERAL
  aws_account_level_id = format(
    "%s-%s-%s",
    var.project,
    var.environment,
    var.component,
  )

  aws_global_level_id = format(
    "%s-%s-%s-%s",
    var.project,
    data.aws_caller_identity.current.account_id,
    var.environment,
    var.component,
  )

  default_tags = merge(var.additional_default_tags, {
    Project     = var.project
    Environment = var.environment
    Component   = var.component
  })

  # SPECIFIC
  flow_log_destination_type   = var.vpc_flow_logs_s3_bucket_arn != null ? "s3" : "cloud-watch-logs"
  flow_log_destination_arn    = var.vpc_flow_logs_s3_bucket_arn != null ? var.vpc_flow_logs_s3_bucket_arn : ""
  create_flow_log_cwlg        = var.vpc_flow_logs_s3_bucket_arn != null ? false : true
  create_flow_log_cw_iam_role = var.vpc_flow_logs_s3_bucket_arn != null ? false : true

  vpc_interface_endpoints_enabled = {
    "s3"            = true
    "rolesanywhere" = var.iam_roles_anywhere_enabled
    "ssm"           = var.ssm_hybrid_activation_registred
    "ssmmessages"   = var.ssm_hybrid_activation_registred
    "eks"           = var.eks_hybrid_nodes_enabled
    "ecr.dkr"       = var.eks_hybrid_nodes_enabled
  }

  vpc_interface_endpoints = [
    for endpoint, enabled in local.vpc_interface_endpoints_enabled :
    endpoint if enabled
  ]
}
