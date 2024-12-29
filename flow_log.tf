data "aws_iam_policy_document" "tgw_flow_logs_trust" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tgw_flow_logs" {
  name               = "${local.aws_account_level_id}-tgw-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.tgw_flow_logs_trust.json

  tags = {
    Name = "${local.aws_account_level_id}-tgw-flow-logs"
  }
}

data "aws_iam_policy_document" "tgw_flow_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["${aws_cloudwatch_log_group.tgw_flow_logs.arn}:*"]
  }
}

resource "aws_iam_role_policy" "tgw_flow_logs" {
  name   = "${local.aws_account_level_id}-tgw-flow-logs"
  role   = aws_iam_role.tgw_flow_logs.id
  policy = data.aws_iam_policy_document.tgw_flow_logs.json
}


resource "aws_flow_log" "transit_gateway" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.tgw_flow_logs.arn

  iam_role_arn = aws_iam_role.tgw_flow_logs.arn

  traffic_type       = "ALL"
  transit_gateway_id = module.transit_gateway.ec2_transit_gateway_id

  max_aggregation_interval = 60 # NOTE: Transit Gateway constraint

  tags = {
    Name = local.aws_account_level_id
  }
}
