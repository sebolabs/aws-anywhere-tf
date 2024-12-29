resource "local_file" "ssm_agent_guide" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.ssm_hybrid_activation_registred &&
    var.generate_ssm_agent_guide_md
  ) ? 1 : 0

  content = sensitive(templatefile("${path.module}/templates/ssm_agent_guide.tftpl", {
    activation_id   = aws_ssm_activation.on_prem[0].id
    activation_code = aws_ssm_activation.on_prem[0].activation_code
    aws_region      = data.aws_region.current.name
  }))

  filename = "${path.module}/GUIDE_SSM_Agent.md"
}
