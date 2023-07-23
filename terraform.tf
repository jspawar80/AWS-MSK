resource "aws_s3_bucket" "example" {
  bucket = "example"
}

resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.example.id
  key    = "debezium.zip"
  source = "debezium.zip"
}

resource "aws_mskconnect_custom_plugin" "example" {
  name         = "debezium-example"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.example.arn
      file_key   = aws_s3_object.example.key
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
