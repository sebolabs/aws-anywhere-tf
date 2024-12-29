resource "aws_cloudwatch_log_group" "on_prem_vpn" {
  name = "/aws/vpn-log/${local.aws_account_level_id}-on-prem"

  retention_in_days = var.cw_logs_retention_days

  tags = {
    Name = "${local.aws_account_level_id}-on-prem-vpn"
  }
}

resource "aws_cloudwatch_log_group" "tgw_flow_logs" {
  name = "/aws/transit-gateway-flow-log/${local.aws_account_level_id}"

  retention_in_days = var.cw_logs_retention_days

  tags = {
    Name = "${local.aws_account_level_id}-tgw-flow-logs"
  }
}
