resource "aws_kms_key" "kms" {
  description             = var.kms_key_description
  deletion_window_in_days = 10
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}

resource "aws_msk_cluster" "example" {
  cluster_name          = var.cluster_name
  kafka_version         = var.kafka_version
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups = [aws_security_group.sg.id]
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.example.arn
    revision = aws_msk_configuration.example.latest_revision
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  open_monitoring {
    prometheus {
      jum_exporter {
        enabled_in_broker = false
      }
      node_exporter {
        enabled_in_broker = false
      }
    }
  }

  client_authentication {
    unauthenticated = true
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.log_group.name
      }
      s3 {
        enabled = false
      }
      firehose {
        enabled = false
      }
    }
  }
}

resource "aws_msk_configuration" "example" {
  kafka_versions = [var.kafka_version]
  name           = "example"

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
zookeeper.connection.timeout.ms = 1000
PROPERTIES
}
