provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "connector_role" {
  name = "${var.my_1st_kf_connector}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "kafkaconnect.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "connector_role_policy" {
  name = "${var.my_1st_kf_connector}-role-policy"
  role = aws_iam_role.connector_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListAllMyBuckets"
        ],
        "Resource": "arn:aws:s3:::*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:ListBucketMultipartUploads"
        ],
        "Resource": "*"
      }
    ]
  })
}
 
variable "my_1st_kf_connector" {
  type = string
  default = "msk-database"
}

resource "aws_s3_bucket" "confluentinc-kafka-connect-s3" {
  bucket = "${var.my_1st_kf_connector}-${random_string.random_string.result}"
}

resource "random_string" "random_string" {
  length = 8
  special = false
  upper = false
  lower = true
  numeric = false
}

resource "aws_s3_object" "connector_code" {
  bucket = aws_s3_bucket.confluentinc-kafka-connect-s3.bucket
  key = "${var.my_1st_kf_connector}.zip"
  content_type = "application/java-archive"
  source = "../${var.my_1st_kf_connector}-10.4.3.zip"
}

resource "aws_mskconnect_custom_plugin" "plugin" {
  name = "${var.my_1st_kf_connector}-plugin"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = "arn:aws:s3:::msk-database"
      file_key = "confluentinc-kafka-connect-s3-10.4.3.zip"
    }
  }
}

resource "aws_mskconnect_connector" "connector" {
  name = var.my_1st_kf_connector
  kafkaconnect_version = "2.7.1"
  capacity {
    autoscaling {
      mcu_count = 1
      min_worker_count = 1
      max_worker_count = 2
      scale_in_policy {
        cpu_utilization_percentage = 20
      }
      scale_out_policy {
        cpu_utilization_percentage = 80
      }
    }
  }
  connector_configuration = {
    "connector.class" = "io.confluent.connect.s3.S3SinkConnector"
    "s3.region" = "us-east-1"
    "format.class" = "io.confluent.connect.s3.format.json.JsonFormat"
    "flush.size" = "100"
    "schema.compatibility" = "NONE"
    "tasks.max" = "5"
    "topics" = "mkc-tutorial-topic1234"
    "partitioner.class" = "io.confluent.connect.storage.partitioner.DefaultPartitioner"
    "storage.class" = "io.confluent.connect.s3.storage.S3Storage"
    "s3.bucket.name" = "msk-database"
    "topics.dir" = "tutorialss"
  }
  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = "b-3.mskdemo.nv5wyw.c14.kafka.us-east-1.amazonaws.com:9092,b-2.mskdemo.nv5wyw.c14.kafka.us-east-1.amazonaws.com:9092,b-1.mskdemo.nv5wyw.c14.kafka.us-east-1.amazonaws.com:9092"
      vpc {
        security_groups = ["sg-0ec362509555033cf"]
        subnets = ["subnet-023144de8df71781a",
                   "subnet-0bcfa14c81ca32bd0",
                   "subnet-01379dc0cc2a99018"]
      }
    }
  }
  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }
  kafka_cluster_encryption_in_transit {
    encryption_type = "PLAINTEXT"
  }
  plugin {
    custom_plugin {
      arn = aws_mskconnect_custom_plugin.plugin.arn
      revision = aws_mskconnect_custom_plugin.plugin.latest_revision
    }
  }
  service_execution_role_arn = aws_iam_role.connector_role.arn
}
