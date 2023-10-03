terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "cassandra_cluster_node_unresponsive_and_resulting_data_unavailability" {
  source    = "./modules/cassandra_cluster_node_unresponsive_and_resulting_data_unavailability"

  providers = {
    shoreline = shoreline
  }
}