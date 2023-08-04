variable "kafka_cluster_policy_name" {
  description = "The name of the Kafka Cluster policy"
  type        = string
  default     = "kafka_cluster_policy"
}

variable "kafka_cluster_policy_description" {
  description = "The description of the Kafka Cluster policy"
  type        = string
  default     = "Policy for Kafka Cluster"
}

variable "custom_kafka_connect_policy_name" {
  description = "The name of the Custom Kafka Connect policy"
  type        = string
  default     = "custom_kafka_connect"
}

variable "custom_kafka_connect_policy_description" {
  description = "The description of the Custom Kafka Connect policy"
  type        = string
  default     = "Policy for Custom Kafka Connect"
}
