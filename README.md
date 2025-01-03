# AWS Anywhere
## Info
It contains the relevant configurations required for performing different integrations between AWS and on-premises environments. These include:
- Site-to-Site VPN
- DNS forwarding for AWS services/resources domain name resolution
- IAM Roles Anywhere
- SSM Agent
- EKS Hybrid Nodes

> NOTE: The configuration contained here was used for a Proof of Concept (PoC) and might not work out of the box for everyone. While the versions of various components used to configure individual pieces are listed in the corresponding `templates/tftpl` files, other configuration elements and peripherals may impact the setup and require additional configurations.

## Blog
[AWS Anywhere - a route to EKS Hybrid Nodes](https://faun.pub/aws-anywhere-a-route-to-eks-hybrid-nodes-ccc1ae703a41)

## Features
The features covered by this module can be enabled using the following environment variables, which are set to `false` by default:
```
on_prem_s2s_vpn_enabled             = true
r53_inbound_resolver_enabled        = true
iam_roles_anywhere_enabled          = true
ssm_advanced_instances_tier_enabled = true
eks_hybrid_nodes_enabled            = true
```

> NOTE: Everything has been tested in the order specified above and applied one by one. Randomly enabling or disabling individual features may lead to unexpected errors when running Terraform. This is due to interdependencies that have not been tested in every possible scenario.

## Guides
Enabled by default, guides are auto-generated upon Terraform apply. Look for `GUIDE_*.md` files in this folder.

# Terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_transit_gateway"></a> [transit\_gateway](#module\_transit\_gateway) | terraform-aws-modules/transit-gateway/aws | ~> 2.12 |
| <a name="module_transit_vpc"></a> [transit\_vpc](#module\_transit\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.16 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.on_prem_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.tgw_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_customer_gateway.on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_ec2_transit_gateway_route.vpc_to_on_prem_via_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.eks_vpc_for_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.transit_vpc_for_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_flow_log.transit_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.eks_hybrid_nodes_descr_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_hybrid_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.rolesanywhere_on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.tgw_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.tgw_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.eks_hybrid_nodes_ecr_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_hybrid_nodes_eks_descr_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.on_prem_ssm_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.on_prem_vpc_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_rolesanywhere_profile.eks_hybrid_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_profile) | resource |
| [aws_rolesanywhere_profile.on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_profile) | resource |
| [aws_rolesanywhere_trust_anchor.on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_trust_anchor) | resource |
| [aws_route.transit_intra_to_on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.transit_private_to_on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_endpoint.inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_security_group.common](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.r53_inbound_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_if_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_activation.on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_activation) | resource |
| [aws_ssm_parameter.on_prem_ca_cert_bundle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_service_setting.advanced_instance_tier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_service_setting) | resource |
| [aws_vpc_endpoint.ddb_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.ddb_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.s3_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_security_group_egress_rule.common_https_to_ddb_gw_ep](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.common_https_to_s3_gw_ep](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.common_https_to_vpc_if_eps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.r53_resolver_inbound_dns_tcp_from_on_prem_vpn_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.r53_resolver_inbound_dns_udp_from_on_prem_vpn_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.vpc_if_eps_https_from_common](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.vpc_if_eps_https_from_on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpn_connection.on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [local_file.bind_dns_guide](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.eks_hybrid_nodes_guide](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rolesanywhere_ca_guide](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssm_agent_guide](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.strongswan_vpn_guide](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_hybrid_nodes_descr_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_hybrid_nodes_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rolesanywhere_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tgw_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tgw_flow_logs_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_default_tags"></a> [additional\_default\_tags](#input\_additional\_default\_tags) | A map with additional default tags to be applied at the AWS provider level | `map(string)` | `{}` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The allowed AWS account ID to prevent you from mistakenly using an incorrect one | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | The TF component name | `string` | `"network"` | no |
| <a name="input_cw_logs_retention_days"></a> [cw\_logs\_retention\_days](#input\_cw\_logs\_retention\_days) | The number of days any CloudWatch logs should be retained | `number` | `3` | no |
| <a name="input_eks_hybrid_nodes_enabled"></a> [eks\_hybrid\_nodes\_enabled](#input\_eks\_hybrid\_nodes\_enabled) | Whether EKS Hybrid Nodes should be configured | `bool` | `false` | no |
| <a name="input_eks_props"></a> [eks\_props](#input\_eks\_props) | A map with EKS relevant properties | <pre>object({<br>    cluster_name    = optional(string)<br>    cluster_version = optional(string)<br>    vpc_name        = optional(string)<br>    vpc_id          = optional(string)<br>    vpc_cidr        = optional(string)<br>    tgw_subnet_ids  = optional(list(string))<br>  })</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name | `string` | n/a | yes |
| <a name="input_generate_bind_dns_guide_md"></a> [generate\_bind\_dns\_guide\_md](#input\_generate\_bind\_dns\_guide\_md) | Whether to generate the Bind DNS Guide as a local file | `bool` | `true` | no |
| <a name="input_generate_eks_hybrid_nodes_guide_md"></a> [generate\_eks\_hybrid\_nodes\_guide\_md](#input\_generate\_eks\_hybrid\_nodes\_guide\_md) | Whether to generate the EKS Hybrid Nodes Guide as a local file | `bool` | `true` | no |
| <a name="input_generate_rolesanywhere_ca_guide_md"></a> [generate\_rolesanywhere\_ca\_guide\_md](#input\_generate\_rolesanywhere\_ca\_guide\_md) | Whether to generate the CA RolesAnywhere Guide as a local file | `bool` | `true` | no |
| <a name="input_generate_ssm_agent_guide_md"></a> [generate\_ssm\_agent\_guide\_md](#input\_generate\_ssm\_agent\_guide\_md) | Whether to generate the SSM Agent Guide as a local file | `bool` | `true` | no |
| <a name="input_generate_strongswan_vpn_guide_md"></a> [generate\_strongswan\_vpn\_guide\_md](#input\_generate\_strongswan\_vpn\_guide\_md) | Whether to generate the Strongswan VPN Guide as a local file | `bool` | `true` | no |
| <a name="input_iam_roles_anywhere_enabled"></a> [iam\_roles\_anywhere\_enabled](#input\_iam\_roles\_anywhere\_enabled) | Whether IAM roles anywhere should be configured | `bool` | `false` | no |
| <a name="input_on_prem_props"></a> [on\_prem\_props](#input\_on\_prem\_props) | A map with on-prem relevant properties | <pre>object({<br>    bgp_asn           = optional(number)<br>    public_ip_address = optional(string)<br>    private_cidr      = optional(string)<br>    vpn_host_ip       = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_on_prem_s2s_vpn_enabled"></a> [on\_prem\_s2s\_vpn\_enabled](#input\_on\_prem\_s2s\_vpn\_enabled) | Whther the Site-to-Site VPN connection to on-prem is enabled | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | The Project name | `string` | n/a | yes |
| <a name="input_r53_inbound_resolver_enabled"></a> [r53\_inbound\_resolver\_enabled](#input\_r53\_inbound\_resolver\_enabled) | Whther the Route53 Inbound Resolver for on-prem is enabled | `bool` | `false` | no |
| <a name="input_ssm_advanced_instances_tier_enabled"></a> [ssm\_advanced\_instances\_tier\_enabled](#input\_ssm\_advanced\_instances\_tier\_enabled) | Whether the SSM advanced-instances tier is enabled. | `bool` | `false` | no |
| <a name="input_ssm_hybrid_activation_registred"></a> [ssm\_hybrid\_activation\_registred](#input\_ssm\_hybrid\_activation\_registred) | Whether the SSM hybrid activation is registered (manually). | `bool` | `false` | no |
| <a name="input_tf_state_bucket_name_prefix"></a> [tf\_state\_bucket\_name\_prefix](#input\_tf\_state\_bucket\_name\_prefix) | Terraform state bucket name prefix | `string` | n/a | yes |
| <a name="input_transit_vpc_cidrs"></a> [transit\_vpc\_cidrs](#input\_transit\_vpc\_cidrs) | A map with Transit VPC and subnets CIDR blocks | <pre>object({<br>    vpc             = string<br>    public_subnets  = list(string)<br>    private_subnets = list(string)<br>    intra_subnets   = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_vpc_flow_logs_s3_bucket_arn"></a> [vpc\_flow\_logs\_s3\_bucket\_arn](#input\_vpc\_flow\_logs\_s3\_bucket\_arn) | The ARN of a dedicated S3 bucket for storing logs. If not provided CW LG will be configured instead | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output___AWS_ACCOUNT_LEVEL_IDENTIFIER__"></a> [\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_](#output\_\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_) | n/a |
| <a name="output_aws_ssm_activation"></a> [aws\_ssm\_activation](#output\_aws\_ssm\_activation) | n/a |
| <a name="output_eks_hybrid_nodes_iam_role_arn"></a> [eks\_hybrid\_nodes\_iam\_role\_arn](#output\_eks\_hybrid\_nodes\_iam\_role\_arn) | n/a |
| <a name="output_guide_bind_dns_path"></a> [guide\_bind\_dns\_path](#output\_guide\_bind\_dns\_path) | n/a |
| <a name="output_guide_eks_hybrid_nodes_path"></a> [guide\_eks\_hybrid\_nodes\_path](#output\_guide\_eks\_hybrid\_nodes\_path) | n/a |
| <a name="output_guide_rolesanywhere_ca_path"></a> [guide\_rolesanywhere\_ca\_path](#output\_guide\_rolesanywhere\_ca\_path) | n/a |
| <a name="output_guide_ssm_agent_path"></a> [guide\_ssm\_agent\_path](#output\_guide\_ssm\_agent\_path) | n/a |
| <a name="output_guide_strongswan_vpn_path"></a> [guide\_strongswan\_vpn\_path](#output\_guide\_strongswan\_vpn\_path) | n/a |
| <a name="output_r53_inbound_resolver_ips"></a> [r53\_inbound\_resolver\_ips](#output\_r53\_inbound\_resolver\_ips) | n/a |
| <a name="output_rolesanywhere_signing_helper_props"></a> [rolesanywhere\_signing\_helper\_props](#output\_rolesanywhere\_signing\_helper\_props) | n/a |
| <a name="output_transit_vpc"></a> [transit\_vpc](#output\_transit\_vpc) | n/a |
<!-- END_TF_DOCS -->
