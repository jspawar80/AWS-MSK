```
# A new internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# A new route table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

# A new subnet association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_az1.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_az2.id
  route_table_id = aws_route_table.example.id
}

# A new NAT gateway with an Elastic IP address
resource "aws_eip" "example" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.subnet_az1.id
}

# A new route table pointing to the NAT gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }
}

# Associating the private route table to the second subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet_az2.id
  route_table_id = aws_route_table.private.id
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/22"
}

resource "aws_subnet" "subnet_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
    client_subnets  = [aws_subnet.subnet_az1.id, aws_subnet.subnet_az2.id]
    ebs_volume_size = 10
    security_groups = [aws_security_group.sg.id]
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

