data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_eks_node_group" "this" {
  count = true ? 1 : 0

  # Required
  cluster_name  = aws_eks_cluster.eks.name
  node_role_arn = true ? aws_iam_role.eks-node[0].arn : null
  subnet_ids    = var.subnet_ids

  scaling_config {
    min_size     = 1
    max_size     = 2
    desired_size = 1
  }

  # Optional
  node_group_name        = true ? null : ""
  node_group_name_prefix = true ? "-" : null

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = ["t3.small"]

#   dynamic "remote_access" {
#     for_each = length(var.remote_access) > 0 ? [var.remote_access] : []

#     content {
#       ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
#       source_security_group_ids = try(remote_access.value.source_security_group_ids, [])
#     }
#   }
}

################################################################################
# IAM Role
################################################################################

locals {
  iam_role_name          = coalesce(true, "eks-node-group")
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  ipv4_cni_policy = { for k, v in {
    AmazonEKS_CNI_Policy = "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy"
  } : k => v if var.cluster_ip_family == "ipv4" }
  ipv6_cni_policy = { for k, v in {
    AmazonEKS_CNI_IPv6_Policy = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/AmazonEKS_CNI_IPv6_Policy"
  } : k => v if var.cluster_ip_family == "ipv6" }
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = true ? 1 : 0

  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks-node" {
  count = true ? 1 : 0

  name        = true ? null : "terraform-iam-role-for-node-group"
  name_prefix = true ? "terraform-iam-role-for-node-group" : null
  path        = null

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = null
  force_detach_policies = true

}

# Policies attached ref https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in merge(
    {
      AmazonEKSWorkerNodePolicy          = "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy"
      AmazonEC2ContainerRegistryReadOnly = "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly"
    },
    local.ipv4_cni_policy,
    local.ipv6_cni_policy
  ) : k => v}

  policy_arn = each.value
  role       = aws_iam_role.eks-node[0].name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in {} : k => v if true }

  policy_arn = each.value
  role       = aws_iam_role.eks-node[0].name
}

################################################################################
# IAM Role Policy
################################################################################

locals {
  create_iam_role_policy = true && length([]) > 0
}

data "aws_iam_policy_document" "role" {
  count = local.create_iam_role_policy ? 1 : 0

  dynamic "statement" {
    for_each = [var.iam_role_policy_statements]

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_role_policy" "this" {
  count = local.create_iam_role_policy ? 1 : 0

  name        = true ? null : local.iam_role_name
  name_prefix = true ? "${local.iam_role_name}-" : null
  policy      = data.aws_iam_policy_document.role[0].json
  role        = aws_iam_role.eks-node[0].id
}