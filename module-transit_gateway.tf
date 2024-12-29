# NOTE: Unfortunately, this module turned out to have limited capabilities, hence additions
module "transit_gateway" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.12"

  name        = local.aws_account_level_id
  description = "Central/Shared Transit Gateway"

  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = false
  enable_default_route_table_propagation = false

  enable_dns_support       = true
  enable_vpn_ecmp_support  = true
  enable_multicast_support = false

  share_tgw = false

  vpc_attachments = merge({
    transit = {
      vpc_id      = module.transit_vpc.vpc_id
      subnet_ids  = module.transit_vpc.private_subnets
      dns_support = true

      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false

      tgw_routes = [
        {
          destination_cidr_block = "172.16.0.0/12"
          blackhole              = true
        },
        {
          destination_cidr_block = "10.0.0.0/8"
          blackhole              = true
        },
      ]

      tags = {
        Name = "${local.aws_account_level_id}-transit-vpc"
      }
    }
    },
  local.additional_vpc_attachments)

  tgw_route_table_tags = {
    Name = "${local.aws_account_level_id}-vpc"
  }
}

### ROUTING CONFIGURATION ##########################################################################

### VPCs

# NOTE: didn't work ~ no route was propagated
# resource "aws_ec2_transit_gateway_route_table_propagation" "vpn_on_prem_for_transit" {
#   count = var.on_prem_s2s_vpn_enabled ? 1 : 0

#   transit_gateway_attachment_id  = aws_vpn_connection.on_prem[0].transit_gateway_attachment_id
#   transit_gateway_route_table_id = module.transit_gateway.ec2_transit_gateway_route_table_id
# }

resource "aws_ec2_transit_gateway_route" "vpc_to_on_prem_via_vpn" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  destination_cidr_block         = var.on_prem_props.private_cidr
  transit_gateway_attachment_id  = aws_vpn_connection.on_prem[0].transit_gateway_attachment_id
  transit_gateway_route_table_id = module.transit_gateway.ec2_transit_gateway_route_table_id
}

### VPN connection

resource "aws_ec2_transit_gateway_route_table" "vpn" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  transit_gateway_id = module.transit_gateway.ec2_transit_gateway_id

  tags = {
    Name = "${local.aws_account_level_id}-on-prem-vpn"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "vpn" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  transit_gateway_attachment_id  = aws_vpn_connection.on_prem[0].transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "transit_vpc_for_vpn" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  transit_gateway_attachment_id  = module.transit_gateway.ec2_transit_gateway_vpc_attachment["transit"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "eks_vpc_for_vpn" {
  count = (
    var.on_prem_s2s_vpn_enabled &&
    var.eks_hybrid_nodes_enabled &&
    var.eks_props != {}
  ) ? 1 : 0

  transit_gateway_attachment_id  = module.transit_gateway.ec2_transit_gateway_vpc_attachment["eks"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn[0].id
}
