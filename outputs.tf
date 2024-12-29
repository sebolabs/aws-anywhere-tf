output "__AWS_ACCOUNT_LEVEL_IDENTIFIER__" {
  value = upper(local.aws_account_level_id)
}

output "transit_vpc" {
  value = {
    vpc_id              = module.transit_vpc.vpc_id
    private_subnets_ids = module.transit_vpc.private_subnets
    public_subnets_ids  = module.transit_vpc.public_subnets
    intra_subnets_ids   = module.transit_vpc.intra_subnets
  }
}

output "guide_strongswan_vpn_path" {
  value = (
    var.on_prem_s2s_vpn_enabled &&
    var.generate_strongswan_vpn_guide_md
  ) ? local_file.strongswan_vpn_guide[0].filename : null
}

output "r53_inbound_resolver_ips" {
  value = (
    var.on_prem_s2s_vpn_enabled &&
    var.r53_inbound_resolver_enabled
  ) ? flatten(aws_route53_resolver_endpoint.inbound[0].ip_address[*].ip) : null
}

output "guide_bind_dns_path" {
  value = (
    var.on_prem_s2s_vpn_enabled &&
    var.r53_inbound_resolver_enabled &&
    var.generate_strongswan_vpn_guide_md
  ) ? local_file.bind_dns_guide[0].filename : null
}

output "rolesanywhere_signing_helper_props" {
  value = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A"
    ) ? {
    trust_anchor_arn = aws_rolesanywhere_trust_anchor.on_prem[0].arn
    role_arn         = aws_iam_role.rolesanywhere_on_prem[0].arn
    profile_arn      = aws_rolesanywhere_profile.on_prem[0].arn
  } : null
}

output "guide_rolesanywhere_ca_path" {
  value = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A" &&
    var.generate_rolesanywhere_ca_guide_md
  ) ? local_file.rolesanywhere_ca_guide[0].filename : null
}

output "aws_ssm_activation" {
  value = var.ssm_hybrid_activation_registred ? {
    activation_id   = aws_ssm_activation.on_prem[0].id
    activation_code = aws_ssm_activation.on_prem[0].activation_code
  } : null
}

output "guide_ssm_agent_path" {
  value = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A" &&
    var.ssm_hybrid_activation_registred &&
    var.generate_ssm_agent_guide_md
  ) ? local_file.ssm_agent_guide[0].filename : null
}

output "eks_hybrid_nodes_iam_role_arn" {
  value = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A" &&
    var.eks_hybrid_nodes_enabled
  ) ? aws_iam_role.eks_hybrid_nodes[0].arn : null
}

output "guide_eks_hybrid_nodes_path" {
  value = (
    var.on_prem_s2s_vpn_enabled &&
    var.eks_hybrid_nodes_enabled
  ) ? local_file.eks_hybrid_nodes_guide[0].filename : null
}
