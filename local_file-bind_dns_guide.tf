resource "local_file" "bind_dns_guide" {
  count = (
    var.on_prem_s2s_vpn_enabled &&
    var.r53_inbound_resolver_enabled &&
    var.generate_bind_dns_guide_md
  ) ? 1 : 0

  content = sensitive(templatefile("${path.module}/templates/bind_dns_guide.tftpl", {
    r53_inbound_resolver_ips = flatten(aws_route53_resolver_endpoint.inbound[0].ip_address[*].ip)
    vpc_interface_endpoints  = local.vpc_interface_endpoints
    aws_region               = data.aws_region.current.name
  }))

  filename = "${path.module}/GUIDE_Bind_DNS.md"
}
