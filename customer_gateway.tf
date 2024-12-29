resource "aws_customer_gateway" "on_prem" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  ip_address = var.on_prem_props.public_ip_address
  bgp_asn    = var.on_prem_props.bgp_asn
  type       = "ipsec.1"

  tags = {
    Name = "${local.aws_account_level_id}-on-prem"
  }
}
