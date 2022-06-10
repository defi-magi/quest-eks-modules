#---------------------------------------------------------------------------------------------------
# EKS Cluster
#---------------------------------------------------------------------------------------------------
module "eks" {
  source                                    = "terraform-aws-modules/eks/aws"
  version                                   = "18.23.0"
  cluster_name                              = local.cluster_name
  cluster_version                           = var.k8s_version
  vpc_id                                    = var.vpc_id
  subnet_ids                                = var.subnet_ids
  cluster_encryption_policy_use_name_prefix = false
  cluster_security_group_use_name_prefix    = false
  iam_role_use_name_prefix                  = false
  node_security_group_use_name_prefix       = false
  cluster_endpoint_private_access           = false
  cluster_endpoint_public_access            = true
  cluster_endpoint_public_access_cidrs      = var.control_plane_api_allow_list_cidrs
  enable_irsa                               = true
  cluster_enabled_log_types                 = var.cluster_log_types
  manage_aws_auth_configmap                 = var.aws_auth_config.manage_aws_auth_configmap
  aws_auth_roles                            = var.aws_auth_config.aws_auth_roles
  aws_auth_users                            = var.aws_auth_config.aws_auth_users
  tags                                      = var.tags

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }

    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
      addon_version            = "v1.11.0-eksbuild.1"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }

    kube-proxy = {}
  }
  # Enable Kubernetes Secret encryption
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  # Managed node groups configuration
  eks_managed_node_groups = local.managed_node_groups

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    disk_size                             = 50
    vpc_security_group_ids                = [aws_security_group.default_node_security_group.id]
    attach_cluster_primary_security_group = true
    create_security_group                 = true
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

# KMS key for Kubernetes Secret encryption
resource "aws_kms_key" "eks" {
  description             = "EKS Secrets Encryption Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags
}
