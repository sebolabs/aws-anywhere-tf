resource "local_file" "strongswan_vpn_guide" {
  count = var.on_prem_s2s_vpn_enabled && var.generate_strongswan_vpn_guide_md ? 1 : 0

  content = sensitive(templatefile("${path.module}/templates/strongswan_vpn_guide.tftpl", {
    # ON-PREM
    on_prem_cgw_public_ip = var.on_prem_props.public_ip_address
    on_prem_network_cidr  = var.on_prem_props.private_cidr
    on_prem_vpn_host_ip   = var.on_prem_props.vpn_host_ip
    # AWS
    aws_vpn_tunnel1_outside_ip  = aws_vpn_connection.on_prem[0].tunnel1_address
    aws_vpn_tunnel1_inside_cidr = aws_vpn_connection.on_prem[0].tunnel1_inside_cidr
    aws_vpn_tunnel1_local_cidr  = "${cidrhost(aws_vpn_connection.on_prem[0].tunnel1_inside_cidr, 1)}/30"
    aws_vpn_tunnel1_remote_cidr = "${cidrhost(aws_vpn_connection.on_prem[0].tunnel1_inside_cidr, 2)}/30"
    aws_vpn_tunnel1_psk         = aws_vpn_connection.on_prem[0].tunnel1_preshared_key
    aws_vpn_tunnel2_outside_ip  = aws_vpn_connection.on_prem[0].tunnel2_address
    aws_vpn_tunnel2_inside_cidr = aws_vpn_connection.on_prem[0].tunnel2_inside_cidr
    aws_vpn_tunnel2_local_cidr  = "${cidrhost(aws_vpn_connection.on_prem[0].tunnel2_inside_cidr, 1)}/30"
    aws_vpn_tunnel2_remote_cidr = "${cidrhost(aws_vpn_connection.on_prem[0].tunnel2_inside_cidr, 2)}/30"
    aws_vpn_tunnel2_psk         = aws_vpn_connection.on_prem[0].tunnel2_preshared_key
    aws_example_vpc_cidr        = module.transit_vpc.vpc_cidr_block
  }))

  filename = "${path.module}/GUIDE_Strongswan_VPN.md"
}
