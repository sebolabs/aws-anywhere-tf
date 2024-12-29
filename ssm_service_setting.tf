# NOTE: allows connecting to on-prem instances with Fleet Manager
resource "aws_ssm_service_setting" "advanced_instance_tier" {
  count = (
    var.ssm_hybrid_activation_registred &&
    var.ssm_advanced_instances_tier_enabled
  ) ? 1 : 0

  setting_id    = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:servicesetting/ssm/managed-instance/activation-tier"
  setting_value = "advanced"
}
