resource "local_file" "eks_hybrid_nodes_guide" {
  count = (
    var.on_prem_s2s_vpn_enabled &&
    var.iam_roles_anywhere_enabled &&
    var.eks_hybrid_nodes_enabled &&
    length(var.eks_props) > 0 &&
    var.generate_eks_hybrid_nodes_guide_md
  ) ? 1 : 0

  content = sensitive(templatefile("${path.module}/templates/eks_hybrid_nodes_guide.tftpl", {
    aws_vpn_tunnel1_inside_cidr = aws_vpn_connection.on_prem[0].tunnel1_inside_cidr
    aws_vpn_tunnel2_inside_cidr = aws_vpn_connection.on_prem[0].tunnel2_inside_cidr
    on_prem_vpn_host_ip         = var.on_prem_props.vpn_host_ip
    eks_cluster_version         = var.eks_props.cluster_version
    eks_vpc_cidr                = var.eks_props.vpc_cidr
    eks_cluster_name            = var.eks_props.cluster_name
    aws_region                  = data.aws_region.current.name
    trust_anchor_arn            = aws_rolesanywhere_trust_anchor.on_prem[0].arn
    profile_arn                 = aws_rolesanywhere_profile.eks_hybrid_nodes[0].arn
    role_arn                    = aws_iam_role.eks_hybrid_nodes[0].arn
  }))

  filename = "${path.module}/GUIDE_EKS_Hybrid_Nodes.md"
}
