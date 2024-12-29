resource "local_file" "rolesanywhere_ca_guide" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A" &&
    var.generate_rolesanywhere_ca_guide_md
  ) ? 1 : 0

  content = sensitive(templatefile("${path.module}/templates/rolesanywhere_ca_guide.tftpl", {
    trust_anchor_arn = aws_rolesanywhere_trust_anchor.on_prem[0].arn
    profile_arn      = aws_rolesanywhere_profile.on_prem[0].arn
    role_arn         = aws_iam_role.rolesanywhere_on_prem[0].arn
    role_name        = split("/", aws_iam_role.rolesanywhere_on_prem[0].arn)[1]
    account_id       = data.aws_caller_identity.current.account_id
    aws_region       = data.aws_region.current.name
  }))

  filename = "${path.module}/GUIDE_RolesAnywhere_CA.md"
}
