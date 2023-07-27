resource "aws_iam_policy" "kafka_cluster_policy" {
  name        = "kafka_cluster_policy"
  description = "Policy for Kafka Cluster"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "kafka:DescribeTopic",
        "kafka:DescribeCluster",
        "kafka:ReadData",
        "kafka:DescribeClusterDynamicConfiguration",
        "kafka:DescribeTransactionalId",
        "kafka:DescribeGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "custom_kafka_connect" {
  name        = "custom_kafka_connect"
  description = "Policy for Custom Kafka Connect"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:CreateTags",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterfacePermission",
        "ec2:AttachNetworkInterface",
        "ec2:DetachNetworkInterface",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:network-interface/*",
        "arn:aws:ec2:*:*:subnet/*",
        "arn:aws:ec2:*:*:security-group/*"
      ]
    }
  ]
}
EOF
}
