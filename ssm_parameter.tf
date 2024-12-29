resource "aws_ssm_parameter" "on_prem_ca_cert_bundle" {
  count = var.iam_roles_anywhere_enabled ? 1 : 0

  name        = "/${var.project}/${var.environment}/${var.component}/on-prem-ca-cert-bundle"
  description = "The on-prem CA certificate bundle data"
  type        = "SecureString"
  value       = "N/A" # NOTE: you must manually upload CA cert

  lifecycle {
    ignore_changes = [value]
  }

  tags = {
    Name = "${local.aws_account_level_id}-on-prem-ca-cert-bundle"
  }
}
