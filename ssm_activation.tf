resource "aws_iam_role_policy_attachment" "on_prem_ssm_agent" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A" &&
    var.ssm_hybrid_activation_registred
  ) ? 1 : 0

  role       = aws_iam_role.rolesanywhere_on_prem[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_ssm_activation" "on_prem" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A" &&
    var.ssm_hybrid_activation_registred
  ) ? 1 : 0

  name               = "${local.aws_account_level_id}-on-prem"
  description        = "On-prem SSM activation"
  iam_role           = aws_iam_role.rolesanywhere_on_prem[0].id
  registration_limit = 1
  depends_on         = [aws_iam_role_policy_attachment.on_prem_ssm_agent]

  tags = {
    Name = "${local.aws_account_level_id}-on-prem"
  }
}
