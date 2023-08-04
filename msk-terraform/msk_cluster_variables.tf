variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "Key for MSK"
}

variable "log_group_name" {
  description = "Name for the log group"
  type        = string
  default     = "MSKLogs"
}

variable "cluster_name" {
  description = "Name for the MSK cluster"
  type        = string
  default     = "new-debezium-kafka-config"
}

variable "kafka_version" {
  description = "Kafka version for the cluster"
  type        = string
  default     = "2.8.1"
}

variable "instance_type" {
  description = "Instance type for the Kafka nodes"
  type        = string
  default     = "kafka.t3.small"
}

variable "volume_size" {
  description = "Volume size for the Kafka nodes"
  type        = number
  default     = 10
}
