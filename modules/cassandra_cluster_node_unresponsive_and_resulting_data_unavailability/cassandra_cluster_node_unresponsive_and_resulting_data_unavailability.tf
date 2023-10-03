resource "shoreline_notebook" "cassandra_cluster_node_unresponsive_and_resulting_data_unavailability" {
  name       = "cassandra_cluster_node_unresponsive_and_resulting_data_unavailability"
  data       = file("${path.module}/data/cassandra_cluster_node_unresponsive_and_resulting_data_unavailability.json")
  depends_on = [shoreline_action.invoke_nodetool_tp_compaction_stats,shoreline_action.invoke_resource_usage_diagnostics,shoreline_action.invoke_restart_node]
}

resource "shoreline_file" "nodetool_tp_compaction_stats" {
  name             = "nodetool_tp_compaction_stats"
  input_file       = "${path.module}/data/nodetool_tp_compaction_stats.sh"
  md5              = filemd5("${path.module}/data/nodetool_tp_compaction_stats.sh")
  description      = "Check if there are any pending repairs or compactions for the affected keyspace"
  destination_path = "/agent/scripts/nodetool_tp_compaction_stats.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "resource_usage_diagnostics" {
  name             = "resource_usage_diagnostics"
  input_file       = "${path.module}/data/resource_usage_diagnostics.sh"
  md5              = filemd5("${path.module}/data/resource_usage_diagnostics.sh")
  description      = "Resource exhaustion on Node (e.g. CPU, memory)"
  destination_path = "/agent/scripts/resource_usage_diagnostics.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_node" {
  name             = "restart_node"
  input_file       = "${path.module}/data/restart_node.sh"
  md5              = filemd5("${path.module}/data/restart_node.sh")
  description      = "Restart the unresponsive Node  and see if it rejoins the cluster. If it does, monitor it closely for any future issues."
  destination_path = "/agent/scripts/restart_node.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_nodetool_tp_compaction_stats" {
  name        = "invoke_nodetool_tp_compaction_stats"
  description = "Check if there are any pending repairs or compactions for the affected keyspace"
  command     = "`chmod +x /agent/scripts/nodetool_tp_compaction_stats.sh && /agent/scripts/nodetool_tp_compaction_stats.sh`"
  params      = ["KEYSPACE"]
  file_deps   = ["nodetool_tp_compaction_stats"]
  enabled     = true
  depends_on  = [shoreline_file.nodetool_tp_compaction_stats]
}

resource "shoreline_action" "invoke_resource_usage_diagnostics" {
  name        = "invoke_resource_usage_diagnostics"
  description = "Resource exhaustion on Node (e.g. CPU, memory)"
  command     = "`chmod +x /agent/scripts/resource_usage_diagnostics.sh && /agent/scripts/resource_usage_diagnostics.sh`"
  params      = ["CPU_OR_MEMORY"]
  file_deps   = ["resource_usage_diagnostics"]
  enabled     = true
  depends_on  = [shoreline_file.resource_usage_diagnostics]
}

resource "shoreline_action" "invoke_restart_node" {
  name        = "invoke_restart_node"
  description = "Restart the unresponsive Node  and see if it rejoins the cluster. If it does, monitor it closely for any future issues."
  command     = "`chmod +x /agent/scripts/restart_node.sh && /agent/scripts/restart_node.sh`"
  params      = []
  file_deps   = ["restart_node"]
  enabled     = true
  depends_on  = [shoreline_file.restart_node]
}

