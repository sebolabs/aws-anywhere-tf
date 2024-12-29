# Gateway Endpoints
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = module.transit_vpc.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = {
    Name = "${local.aws_account_level_id}-s3-gw"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3_gateway" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_gateway.id
  route_table_id  = module.transit_vpc.private_route_table_ids[0]
}

resource "aws_vpc_endpoint" "ddb_gateway" {
  vpc_id       = module.transit_vpc.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  tags = {
    Name = "${local.aws_account_level_id}-ddb-gw"
  }
}

resource "aws_vpc_endpoint_route_table_association" "ddb_gateway" {
  vpc_endpoint_id = aws_vpc_endpoint.ddb_gateway.id
  route_table_id  = module.transit_vpc.private_route_table_ids[0]
}

# Interface Endpoints
resource "aws_vpc_endpoint" "interface" {
  for_each            = { for k, v in local.vpc_interface_endpoints : v => k }
  vpc_id              = module.transit_vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.transit_vpc.intra_subnets
  security_group_ids  = [aws_security_group.vpc_if_endpoints[0].id]
  private_dns_enabled = true

  dns_options {
    private_dns_only_for_inbound_resolver_endpoint = contains(["s3", "dynamodb"], each.key) ? true : false
  }

  tags = {
    Name = "${local.aws_account_level_id}-${each.key}-if"
  }

  depends_on = [
    aws_vpc_endpoint.s3_gateway,
    aws_vpc_endpoint.ddb_gateway,
  ]
}
