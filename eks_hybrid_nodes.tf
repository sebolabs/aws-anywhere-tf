locals {
  additional_vpc_attachments = (
    !var.eks_hybrid_nodes_enabled &&
    length(var.eks_props) == 0
    ) ? {} : {
    eks = {
      vpc_id      = var.eks_props.vpc_id
      subnet_ids  = var.eks_props.tgw_subnet_ids
      dns_support = true

      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false

      tags = {
        Name = var.eks_props.vpc_name
      }
    }
  }
}

data "aws_iam_policy_document" "eks_hybrid_nodes_trust" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
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
}

resource "aws_iam_role" "eks_hybrid_nodes" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
  ) ? 1 : 0

  name               = "${local.aws_account_level_id}-eks-hybrid-nodes"
  assume_role_policy = data.aws_iam_policy_document.eks_hybrid_nodes_trust[0].json

  tags = {
    Name = "${local.aws_account_level_id}-eks-hybrid-nodes"
  }
}

data "aws_iam_policy_document" "eks_hybrid_nodes_descr_cluster" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
  ) ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_hybrid_nodes_descr_cluster" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
  ) ? 1 : 0

  name   = "${local.aws_account_level_id}-eks-hybrid-nodes-descr-cluster"
  policy = data.aws_iam_policy_document.eks_hybrid_nodes_descr_cluster[0].json

  tags = {
    Name = "${local.aws_account_level_id}-eks-hybrid-nodes-descr-cluster"
  }
}

resource "aws_iam_role_policy_attachment" "eks_hybrid_nodes_eks_descr_cluster" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
  ) ? 1 : 0

  role       = aws_iam_role.eks_hybrid_nodes[0].name
  policy_arn = aws_iam_policy.eks_hybrid_nodes_descr_cluster[0].arn
}

resource "aws_iam_role_policy_attachment" "eks_hybrid_nodes_ecr_pull" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
  ) ? 1 : 0

  role       = aws_iam_role.eks_hybrid_nodes[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_rolesanywhere_profile" "eks_hybrid_nodes" {
  count = (
    var.iam_roles_anywhere_enabled &&
    try(aws_ssm_parameter.on_prem_ca_cert_bundle[0].value != "N/A", false) &&
    var.eks_hybrid_nodes_enabled
  ) ? 1 : 0

  name      = "${local.aws_account_level_id}-eks-hybrid-nodes"
  enabled   = true
  role_arns = [aws_iam_role.eks_hybrid_nodes[0].arn]
}
