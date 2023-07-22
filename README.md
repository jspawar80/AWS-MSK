```
provider "aws" {
  region = "us-west-2" 
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id
  depends_on    = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2c"
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.101.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.102.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.103.0/24"
  availability_zone = "us-west-2c"
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

```

```
provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet1.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Security Group for MSK cluster"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_configuration" "example" {
  name = "test"
  kafka_versions    = ["2.8.1"]
  server_properties = <<PROPERTIES
auto.create.topics.enable = true
zookeeper.connection.timeout.ms = 1000
PROPERTIES
}

resource "aws_msk_cluster" "example" {
  cluster_name          = "test"
  kafka_version         = "2.8.1"
  number_of_broker_nodes = 2
  enhanced_monitoring = "DEFAULT"

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.sg.id]
    storage_info {
      ebs_storage_info {
        volume_size = 1000
      }
    }  # <-- Add this closing brace for broker_node_group_info block.

    configuration_info {
      arn      = aws_msk_configuration.example.arn
      revision = aws_msk_configuration.example.latest_revision
    }

    encryption_info {
      encryption_at_rest_kms_key_arn = aws_kms_key.example.arn
      encryption_in_transit {
        client_broker = "PLAINTEXT"
        in_cluster    = true
      }
    }

    client_authentication {
      sasl {
        iam = true
      }
    }

    open_monitoring {
      prometheus {
        jmx_exporter {
          enabled_in_broker = true
        }
        node_exporter {
          enabled_in_broker = true
        }
      }
    }

    logging_info {
      broker_logs {
        cloudwatch_logs {
          enabled = true
          log_group = "<your-log-group>"
        }
      }
    }
  }  # <-- Add this closing brace for aws_msk_cluster block.
}


resource "aws_kms_key" "example" {
  description = "KMS key for encrypting MSK data at rest"
  is_enabled  = true
}

```

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

