resource "aws_security_group" "default_node_security_group" {
  name   = local.default_node_security_group
  vpc_id = var.vpc_id

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 30000
    to_port     = 32767
    protocol    = "TCP"
    cidr_blocks = [
"10.0.0.0/16"
    ]
  }

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 9443
    to_port     = 9443
    protocol    = "TCP"
    cidr_blocks = [
"10.0.0.0/16"
    ]
  }

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [
"10.0.0.0/16"
    ]
  }

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [
"10.0.0.0/16"
    ]
  }

  ingress {
    description = "Inbound access to EKS cluster."
    from_port   = 8052
    to_port     = 8052
    protocol    = "TCP"
    cidr_blocks = [
      "192.168.0.0/19",
      "172.16.0.0/18",
      "10.10.0.0/16",
      "10.11.0.0/16",
      "10.12.0.0/16",
      "10.16.0.0/16"
    ]
  }
}
