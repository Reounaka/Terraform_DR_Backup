resource "aws_iam_policy" "commvault_s3_policy" {
  name="commvault_s3_policy"
  # ... other configuration ...
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1490385696805",
            "Action": [
                "s3:CreateBucket",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectRetention",
                "s3:PutObjectTagging",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:ListBucketVersions",
                "s3:PutBucketObjectLockConfiguration"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
POLICY
}
resource "aws_iam_policy" "commvault_ec2_policy" {
  name ="commvault_ec2_policy"
  # ... other configuration ...
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ConfigureBackupAndRestore",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:CreateImage",
                "ec2:DescribeSnapshots",
                "ec2:StartInstances",
                "ec2:DescribeVolumes",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeKeyPairs",
                "ec2:CreateTags",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:DeleteNetworkInterface",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:DescribeVolumeAttribute",
                "ec2:CreateVolume",
                "ec2:CreateNetworkInterface",
                "ec2:DisassociateIamInstanceProfile",
                "ec2:DescribeSubnets",
                "ec2:AttachVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeRegions",
                "ec2:GetConsoleOutput",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeAvailabilityZones",
                "ec2:CreateSnapshot",
                "ec2:DescribeInstanceStatus",
                "ec2:DetachNetworkInterface",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DescribeTags",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeImages",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpcEndpoints",
                "ec2:GetEbsEncryptionByDefault",
                "ec2:GetEbsDefaultKmsKeyId",
                "ec2:AssociateIamInstanceProfile",
                "ec2:AttachNetworkInterface",
                "ec2:RegisterImage",
                "iam:GetAccountAuthorizationDetails",
                "iam:GetRole",
                "iam:ListRoles",
                "iam:ListInstanceProfiles",
                "iam:GetInstanceProfile",
                "iam:GetUser",
                "kms:ListAliases",
                "ebs:CompleteSnapshot",
                "ebs:GetSnapshotBlock",
                "ebs:PutSnapshotBlock",
                "ebs:StartSnapshot",
                "ebs:ListChangedBlocks",
                "ebs:ListSnapshotBlocks"
            ],
            "Resource": "*"
        },
        {
            "Sid": "RestrictedVolumeAndSnapshotDeletion",
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteVolume",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/_GX_BACKUP_": "*"
                }
            }
        },
        {
            "Sid": "RestrictedTagDeletion",
            "Effect": "Allow",
            "Action": "ec2:DeleteTags",
            "Resource": "*",
            "Condition": {
                "ForAnyValue:StringEquals": {
                    "aws:TagKeys": [
                        "CV_Retain_Snap",
                        "CV_Integrity_Snap",
                        "_GX_BACKUP_",
                        "_GX_AMI_",
                        "Name",
                        "Description"
                    ]
                }
            }
        },
        {
            "Sid": "RestrictedVolumeDetach",
            "Effect": "Allow",
            "Action": "ec2:DetachVolume",
            "Resource": "arn:aws:ec2:*:*:volume/*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/_GX_BACKUP_": "*"
                }
            }
        },
        {
            "Sid": "RestrictedDeleteInstance1",
            "Effect": "Allow",
            "Action": "ec2:TerminateInstances",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/CV_Integrity_Snap": "*"
                }
            }
        },
        {
            "Sid": "RestrictedDeleteInstance2",
            "Effect": "Allow",
            "Action": "ec2:TerminateInstances",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/_GX_BACKUP_": "*"
                }
            }
        },
        {
            "Sid": "AllowDetachfromInstance",
            "Effect": "Allow",
            "Action": "ec2:DetachVolume",
            "Resource": "arn:aws:ec2:*:*:instance/*"
        },
        {
            "Sid": "RestrictPassRoleToEC2",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "ec2.amazonaws.com"
                }
            }
        },
        {
            "Sid": "HotaddBackupAddon",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumesModifications",
                "ec2:ModifySnapshotAttribute",
                "ec2:ModifyVolume"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ImportRestoreAddon",
            "Effect": "Allow",
            "Action": [
                "ec2:ModifyImageAttribute",
                "ec2:ImportImage",
                "ec2:DescribeImportImageTasks",
                "ec2:CancelImportTask"
            ],
            "Resource": "*"
        },
        {
            "Sid": "KMSPermissionsIfNotAllowedAtKeyPolicy",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:ListResourceTags",
                "kms:TagResource",
                "kms:CreateKey",
                "kms:CreateGrant",
                "kms:DescribeKey",
                "kms:ReEncryptFrom",
                "kms:ReEncryptTo",
                "kms:GenerateDataKey",
                "kms:GenerateDataKeyWithoutPlaintext",
                "kms:GenerateDataKeyPairWithoutPlaintext",
                "kms:GenerateDataKeyPair",
                "kms:Encrypt",
                "kms:ListGrants",
                "kms:ListKeys",
                "kms:ListAliases",
                "kms:CreateAlias"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AgentlessRestore",
            "Effect": "Allow",
            "Action": [
                "ssm:CancelCommand",
                "ssm:ListCommands",
                "ssm:DescribeInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Sid": "RestrictedSendCommandForAgentlessRestore",
            "Effect": "Allow",
            "Action": [
                "ssm:SendCommand"
            ],
            "Resource": [
                "arn:aws:ssm:*:*:document/AWS-RunPowerShellScript",
                "arn:aws:ssm:*:*:document/AWS-UpdateSSMAgent",
                "arn:aws:ssm:*:*:document/AWS-RunShellScript",
                "arn:aws:ec2:*:*:instance/*"
            ]
        },
        {
            "Sid": "S3PermissionForAgentlessandImportRestores",
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:PutBucketPublicAccessBlock",
                "s3:PutEncryptionConfiguration",
                "s3:PutBucketAcl",
                "s3:PutObjectTagging",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SnapReplication",
            "Effect": "Allow",
            "Action": [
                "ec2:CopySnapshot",
                "ec2:ModifySnapshotAttribute"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VPCBackupPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:GetManagedPrefixListEntries",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeTransitGateways",
                "ec2:DescribeNatGateways",
                "ec2:GetSubnetCidrReservations",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeTransitGatewayAttachments",
                "ec2:DescribeManagedPrefixLists",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeRouteTables",
                "ec2:DescribeVpnGateways",
                "ec2:DescribeCarrierGateways",
                "ec2:DescribeEgressOnlyInternetGateways"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VPCRestorePermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVpc",
                "ec2:DeleteVpc",
                "ec2:AssociateVpcCidrBlock",
                "ec2:DescribeDhcpOptions",
                "ec2:AssociateDhcpOptions",
                "ec2:CreateSubnet",
                "ec2:ModifySubnetAttribute",
                "ec2:ModifyVpcAttribute",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSecurityGroupRules",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:DeleteSecurityGroup",
                "ec2:AssignPrivateIpAddresses"
            ],
            "Resource": "*"
        },
        {
            "Sid": "EbsDirectOptional",
            "Effect": "Allow",
            "Action": [
                "iam:SimulatePrincipalPolicy"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

output "commvault_ec2_policy_arn" {
  value = aws_iam_policy.commvault_ec2_policy.arn
}

output "commvault_s3_policy_arn" {
  value = aws_iam_policy.commvault_s3_policy.arn
}
