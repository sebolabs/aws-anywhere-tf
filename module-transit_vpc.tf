module "transit_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.16"

  name            = "${local.aws_account_level_id}-transit"
  cidr            = var.transit_vpc_cidrs.vpc
  public_subnets  = var.transit_vpc_cidrs.public_subnets
  private_subnets = var.transit_vpc_cidrs.private_subnets
  intra_subnets   = var.transit_vpc_cidrs.intra_subnets
  azs             = data.aws_availability_zones.available.names

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true

  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = local.create_flow_log_cwlg
  create_flow_log_cloudwatch_iam_role             = local.create_flow_log_cw_iam_role
  flow_log_destination_type                       = local.flow_log_destination_type
  flow_log_destination_arn                        = local.flow_log_destination_arn
  flow_log_cloudwatch_log_group_retention_in_days = var.cw_logs_retention_days
  flow_log_file_format                            = "plain-text"
  flow_log_log_format                             = chomp(trimspace(file("${path.module}/files/vpc-flow-log-format")))

  manage_default_network_acl    = true
  default_network_acl_name      = "${local.aws_account_level_id}-default"
  default_network_acl_tags      = { Name = "${local.aws_account_level_id}-default" }
  manage_default_route_table    = true
  default_route_table_name      = "${local.aws_account_level_id}-default"
  default_route_table_tags      = { Name = "${local.aws_account_level_id}-default" }
  manage_default_security_group = true
  default_security_group_name   = "${local.aws_account_level_id}-default"
  default_security_group_tags   = { Name = "${local.aws_account_level_id}-default" }
}

# TODO: Internet monitor ?

### ROUTING CONFIGURATION ##########################################################################

# NOTE: for testing only
resource "aws_route" "transit_private_to_on_prem" {
  count = var.on_prem_s2s_vpn_enabled ? 1 : 0

  route_table_id         = module.transit_vpc.private_route_table_ids[0]
  destination_cidr_block = var.on_prem_props.private_cidr
  transit_gateway_id     = module.transit_gateway.ec2_transit_gateway_id
}

# NOTE: for VPC Interface Endpoints and R53 Inbound Resolver
resource "aws_route" "transit_intra_to_on_prem" {
  count = var.on_prem_s2s_vpn_enabled && var.r53_inbound_resolver_enabled ? 1 : 0

  route_table_id         = module.transit_vpc.intra_route_table_ids[0]
  destination_cidr_block = var.on_prem_props.private_cidr
  transit_gateway_id     = module.transit_gateway.ec2_transit_gateway_id
}
