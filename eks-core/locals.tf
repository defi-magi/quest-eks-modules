locals {
  vpc_cni_role_name           = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "vpc-cni-role", var.common_tags.index)
  cluster_name                = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", var.common_tags.environment, var.common_tags.index)
  default_node_security_group = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "default-node-sg", var.common_tags.index)
  # find the full list arguments that can be set for the node groups in the official GitHub documentation
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.21.0/examples/eks_managed_node_group/main.tf
  managed_node_groups = {
    for k, v in var.managed_node_groups : k => {
      name                                   = format("%s-%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "node-group", v.name, v.index)
      index                                  = v.index
      use_name_prefix                        = false
      cluster_security_group_use_name_prefix = false
      iam_role_use_name_prefix               = false
      security_group_use_name_prefix         = false
      subnet_ids                             = v.subnet_ids
      ami_id                                 = v.ami_id
      desired_size                           = v.desired_size
      max_size                               = v.max_size
      min_size                               = v.min_size
      instance_types                         = v.instance_types
      capacity_type                          = v.capacity_type
      ebs_optimized                          = v.ebs_optimized
      disable_api_termination                = v.disable_api_termination
      create_iam_role                        = v.create_iam_role
      iam_role_description                   = v.iam_role_description
      iam_role_tags                          = v.iam_role_tags
      iam_role_additional_policies           = v.iam_role_additional_policies
      labels                                 = v.labels
      metadata_options                       = v.metadata_options
      taints                                 = v.taints
      create_security_group                  = v.create_security_group
      security_group_description             = v.security_group_description
      security_group_rules                   = v.security_group_rules
      security_group_tags                    = v.security_group_tags
    }
  }
}
