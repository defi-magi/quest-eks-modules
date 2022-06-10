locals {
  default_node_security_group = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "default-node-sg", var.common_tags.index)
}

resource "aws_security_group" "default_node_security_group" {
  name   = local.default_node_security_group
  vpc_id = var.vpc_id

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
