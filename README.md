```
wget https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip
sudo apt-get install unzip
unzip terraform_0.15.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
```

```
resource "aws_kms_key" "kms" {
  description             = "Key for MSK"
  deletion_window_in_days = 10
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "MSKLogs"
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups = [aws_security_group.sg.id]
    storage_info {
      ebs_storage_info {
        provisioned_throughput {
          enabled           = true
          volume_throughput = 250
        }
        volume_size = 1000
      }
    }
  }

  client_authentication {
    sasl {
      iam = true
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = true
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = false
      }
      node_exporter {
        enabled_in_broker = false
      }
    }
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

  configuration_info {
    arn      = aws_msk_configuration.example.arn
    revision = aws_msk_configuration.example.latest_revision
  }
}

resource "aws_msk_configuration" "example" {
  kafka_versions = ["2.8.1"]
  name           = "example"

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
zookeeper.connection.timeout.ms = 1000
PROPERTIES
}
```
