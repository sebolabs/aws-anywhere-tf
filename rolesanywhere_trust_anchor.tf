resource "aws_rolesanywhere_trust_anchor" "on_prem" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A"
  ) ? 1 : 0

  name    = "${local.aws_account_level_id}-on-prem"
  enabled = true

  source {
    source_type = "CERTIFICATE_BUNDLE"
    source_data {
      x509_certificate_data = aws_ssm_parameter.on_prem_ca_cert_bundle[0].value
    }
  }

  tags = {
    Name = "${local.aws_account_level_id}-on-prem"
  }
}

data "aws_iam_policy_document" "rolesanywhere_trust" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A"
  ) ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity",
    ]

    principals {
      type        = "Service"
      identifiers = ["rolesanywhere.amazonaws.com"]
    }

    condition {
      variable = "aws:SourceArn"
      test     = "ArnEquals"
      values   = [aws_rolesanywhere_trust_anchor.on_prem[0].arn]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_hybrid_activation_registred ? ["ssm.amazonaws.com"] : []

    content {
      effect = "Allow"

      actions = [
        "sts:AssumeRole",
      ]

      principals {
        type        = "Service"
        identifiers = [statement.value]
      }
    }
  }
}

resource "aws_iam_role" "rolesanywhere_on_prem" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A"
  ) ? 1 : 0

  name               = "${local.aws_account_level_id}-rolesanywhere-on-prem"
  assume_role_policy = data.aws_iam_policy_document.rolesanywhere_trust[0].json

  tags = {
    Name = "${local.aws_account_level_id}-rolesanywhere-on-prem"
  }
}

# NOTE: this is just for testing purposes
resource "aws_iam_role_policy_attachment" "on_prem_vpc_full_access" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A"
  ) ? 1 : 0

  role       = aws_iam_role.rolesanywhere_on_prem[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_rolesanywhere_profile" "on_prem" {
  count = (
    var.iam_roles_anywhere_enabled &&
    aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A"
  ) ? 1 : 0

  name      = "${local.aws_account_level_id}-on-prem"
  enabled   = true
  role_arns = [aws_iam_role.rolesanywhere_on_prem[0].arn]

  # NOTE: this is just for testing purposes
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]

  duration_seconds = 14400 # 4h
}
