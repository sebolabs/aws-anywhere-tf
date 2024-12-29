resource "aws_vpn_connection" "on_prem" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  customer_gateway_id = aws_customer_gateway.on_prem[0].id
  transit_gateway_id  = module.transit_gateway.ec2_transit_gateway_id
  type                = aws_customer_gateway.on_prem[0].type
  static_routes_only  = true # NOTE: no BGP

  local_ipv4_network_cidr  = var.on_prem_props.private_cidr # NOTE: on-prem side
  remote_ipv4_network_cidr = "0.0.0.0/0"                    # NOTE: AWS side, any VPC with any CIDR

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.on_prem_vpn.arn
      log_output_format = "json"
    }
  }

  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.on_prem_vpn.arn
      log_output_format = "json"
    }
  }

  tags = {
    Name = "${local.aws_account_level_id}-on-prem"
  }
}
