resource "aws_route53_resolver_endpoint" "inbound" {
  count = var.on_prem_s2s_vpn_enabled && var.r53_inbound_resolver_enabled ? 1 : 0

  name                   = "${local.aws_account_level_id}-inbound"
  direction              = "INBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [aws_security_group.r53_inbound_resolver[0].id]

  dynamic "ip_address" {
    for_each = module.transit_vpc.intra_subnets
    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Name = "${local.aws_account_level_id}-inbound"
  }
}
