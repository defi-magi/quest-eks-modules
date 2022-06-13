#---------------------------------------------------------------------------------------------------
# Example variables file, please review each of these variables and update as necessary
#---------------------------------------------------------------------------------------------------
common_tags = {
  application-id = "eks"
  project        = "quest"
  index          = "00"
  team           = "For the Horde"
  environment    = "dev"
  automated-by   = "terraform"
  created-by     = "Alex"
}

k8s_version = "1.22"

vpc_id = "vpc-id-goes-here"

subnet_ids = ["subnet-00-id-goes-here", "subnet-01-id-goes-here", "subnet-02-id-goes-here"]

control_plane_api_allow_list_cidrs = []

instance_types = ["t3.medium"]

cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

aws_auth_config = {
  manage_aws_auth_configmap = false
  aws_auth_users            = []
  aws_auth_roles = [ =
    {
      rolearn  = "role-arn-goes-here"
      username = "role1"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "role-arn-goes-here"
      username = "role3"
      groups   = ["system:masters"]
    },
  ]
}

# find the full list arguments that can be set for the node groups in the official GitHub documentation
# https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.21.0/examples/eks_managed_node_group/main.tf
# in order to add additional arguments to the map the local in 'eks-cluster.tf' must be updated
managed_node_groups = {
  general_purpose_compute = {
    name                    = "gpc"
    index                   = "00"
    subnet_ids              = ["subnet-00-id-goes-here", "subnet-01-id-goes-here", "subnet-02-id-goes-here"]
    ami_id                  = null
    desired_size            = 3
    max_size                = 5
    min_size                = 3
    instance_types          = ["t3.medium"]
    capacity_type           = "ON_DEMAND"
    ebs_optimized           = false
    disable_api_termination = false
    create_iam_role         = true
    iam_role_name           = null
    iam_role_description    = null
    iam_role_tags = {
      Purpose = "General Purpose Compute node group IAM role"
    }
    iam_role_additional_policies = []
    labels = {
      NodeGroupPurpose = "GeneralPurposeCompute"
      IsSpotNode       = "false"
      IsOnDemandNode   = "false"
      IsMasterNode     = "true"
    }
    taints = [
      # {
      #   key    = "dedicated"
      #   value  = "gpuGroup"
      #   effect = "NO_SCHEDULE"
      # }
    ]
    metadata_options = {
      "http_endpoint" : "enabled",
      "http_put_response_hop_limit" : 2,
      "http_tokens" : "required"
    }
    create_security_group      = true
    security_group_description = null
    security_group_rules = {
      # phoneOut = {
      #   description = "Hello CloudFlare"
      #   protocol    = "udp"
      #   from_port   = 53
      #   to_port     = 53
      #   type        = "egress"
      #   cidr_blocks = ["1.1.1.1/32"]
      # }
      # phoneHome = {
      #   description                   = "Hello cluster"
      #   protocol                      = "udp"
      #   from_port                     = 53
      #   to_port                       = 53
      #   type                          = "egress"
      #   source_cluster_security_group = true # bit of reflection lookup
      # }
    }
    security_group_tags = {
      Purpose = "General Purpose Compute node group security group"
    }
  }
}
