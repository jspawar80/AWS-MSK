resource "aws_mskconnect_connector" "example" {
  name = "example"

  kafkaconnect_version = "2.7.1"

  capacity {
    autoscaling {
      mcu_count        = 1
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
    "connector.class" = "com.github.jcustenborder.kafka.connect.simulator.SimulatorSinkConnector"
    "tasks.max"       = "1"
    "topics"          = "example"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.example.bootstrap_brokers_tls

      vpc {
        security_groups = [aws_security_group.sg.id]
        subnets         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }


#data "aws_mskconnect_custom_plugin" "example" {
 # name = "example-debezium-1"
  #arn      = aws_mskconnect_custom_plugin.example.arn
  #latest_reversion = ID
#}

  service_execution_role_arn = aws_iam_role.example.arn
}
