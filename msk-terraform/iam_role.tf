resource "aws_iam_role" "example" {
  name = var.iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "kafkaconnect.amazonaws.com""
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kafka_cluster_policy_attach" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.kafka_cluster_policy.arn
}

resource "aws_iam_role_policy_attachment" "custom_kafka_connect_attach" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.custom_kafka_connect.arn
}
