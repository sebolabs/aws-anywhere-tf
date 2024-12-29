# VPC Interface Endpoints
resource "aws_security_group" "vpc_if_endpoints" {
  count = length(local.vpc_interface_endpoints) > 0 ? 1 : 0

  name        = "${local.aws_account_level_id}-vpc-if-endpoints"
  description = "The VPC Interface Endpoints SG"
  vpc_id      = module.transit_vpc.vpc_id

  tags = {
    Name = "${local.aws_account_level_id}-vpc-if-endpoints"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_if_eps_https_from_common" {
  count = length(local.vpc_interface_endpoints) > 0 ? 1 : 0

  security_group_id            = aws_security_group.vpc_if_endpoints[0].id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.common.id

  tags = {
    Name = "${local.aws_account_level_id}-vpc-if-eps-https-from-common"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_if_eps_https_from_on_prem" {
  count = (
    length(local.vpc_interface_endpoints) > 0 &&
    var.on_prem_s2s_vpn_enabled &&
    var.r53_inbound_resolver_enabled
  ) ? 1 : 0

  security_group_id = aws_security_group.vpc_if_endpoints[0].id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = var.on_prem_props.private_cidr

  tags = {
    Name = "${local.aws_account_level_id}-vpc-if-eps-https-from-on-prem"
  }
}

# Route53 Inbound Resolver
resource "aws_security_group" "r53_inbound_resolver" {
  count = var.on_prem_s2s_vpn_enabled && var.r53_inbound_resolver_enabled ? 1 : 0

  name        = "${local.aws_account_level_id}-r53-inbound-resolver"
  description = "The Route53 Inbound Resolver SG"
  vpc_id      = module.transit_vpc.vpc_id

  tags = {
    Name = "${local.aws_account_level_id}-r53-inbound-resolver"
  }
}

resource "aws_vpc_security_group_ingress_rule" "r53_resolver_inbound_dns_udp_from_on_prem_vpn_host" {
  count = var.on_prem_s2s_vpn_enabled && var.r53_inbound_resolver_enabled ? 1 : 0

  security_group_id = aws_security_group.r53_inbound_resolver[0].id
  ip_protocol       = "udp"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = "${var.on_prem_props.vpn_host_ip}/32"

  tags = {
    Name = "${local.aws_account_level_id}-r53-inbound-resolver-from-on-prem-vpn-host"
  }
}

resource "aws_vpc_security_group_ingress_rule" "r53_resolver_inbound_dns_tcp_from_on_prem_vpn_host" {
  count = var.on_prem_s2s_vpn_enabled && var.r53_inbound_resolver_enabled ? 1 : 0

  security_group_id = aws_security_group.r53_inbound_resolver[0].id
  ip_protocol       = "tcp"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = "${var.on_prem_props.vpn_host_ip}/32"

  tags = {
    Name = "${local.aws_account_level_id}-r53-inbound-resolver-from-on-prem-vpn-host"
  }
}

# VPC Common SG
resource "aws_security_group" "common" {
  name        = "${local.aws_account_level_id}-common"
  description = "The common SG providing access to trusted endpoints"
  vpc_id      = module.transit_vpc.vpc_id

  tags = {
    Name = "${local.aws_account_level_id}-common"
  }
}

resource "aws_vpc_security_group_egress_rule" "common_https_to_s3_gw_ep" {
  security_group_id = aws_security_group.common.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_id    = aws_vpc_endpoint.s3_gateway.prefix_list_id

  tags = {
    Name = "${local.aws_account_level_id}-common-https-to-s3-gw-ep"
  }
}

resource "aws_vpc_security_group_egress_rule" "common_https_to_ddb_gw_ep" {
  security_group_id = aws_security_group.common.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_id    = aws_vpc_endpoint.ddb_gateway.prefix_list_id

  tags = {
    Name = "${local.aws_account_level_id}-common-https-to-ddb-gw-ep"
  }
}

resource "aws_vpc_security_group_egress_rule" "common_https_to_vpc_if_eps" {
  count = length(local.vpc_interface_endpoints) > 0 ? 1 : 0

  security_group_id            = aws_security_group.common.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.vpc_if_endpoints[0].id

  tags = {
    Name = "${local.aws_account_level_id}-common-https-to-vpc-if-eps"
  }
}
