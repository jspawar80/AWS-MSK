resource "aws_iam_policy" "kafka_cluster_policy" {
  name        = var.kafka_cluster_policy_name
  description = var.kafka_cluster_policy_description

  policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
                {
                        "Sid": "VisualEditor0",
                        "Effect": "Allow",
                        "Action": [
                                "kafka-cluster:DescribeTopicDynamicConfiguration",
                                "kafka-cluster:DescribeCluster",
                                "kafka-cluster:ReadData",
                                "kafka-cluster:DescribeTopic",
                                "kafka-cluster:DescribeTransactionalId",
                                "kafka-cluster:DescribeGroup",
                                "kafka-cluster:DescribeClusterDynamicConfiguration"
                        ],
                        "Resource": "*"
                }
        ]
}
EOF
}

resource "aws_iam_policy" "custom_kafka_connect" {
  name        = var.custom_kafka_connect_policy_name
  description = var.custom_kafka_connect_policy_description

  policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
                {
                        "Effect": "Allow",
                        "Action": [
                                "ec2:CreateNetworkInterface"
                        ],
                        "Resource": "arn:aws:ec2:*:*:network-interface/*"
                },
                {
                        "Effect": "Allow",
                        "Action": [
                                "ec2:CreateNetworkInterface"
                        ],
                        "Resource": [
                                "arn:aws:ec2:*:*:subnet/*",
                                "arn:aws:ec2:*:*:security-group/*"
                        ]
                },
                {
                        "Effect": "Allow",
                        "Action": [
                                "ec2:CreateTags"
                        ],
                        "Resource": "arn:aws:ec2:*:*:network-interface/*"
                },
                {
                        "Effect": "Allow",
                        "Action": [
                                "ec2:DescribeNetworkInterfaces",
                                "ec2:CreateNetworkInterfacePermission",
                                "ec2:AttachNetworkInterface",
                                "ec2:DetachNetworkInterface",
                                "ec2:DeleteNetworkInterface"
                        ],
                        "Resource": "arn:aws:ec2:*:*:network-interface/*"
                }
        ]
}
EOF
}
