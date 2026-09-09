output "cosmosdb_account_id" {
  description = "Cosmos DB account resource ID."
  value       = module.cosmosdb.id
}

output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint."
  value       = module.cosmosdb.endpoint
}

output "diagnostic_setting_ids" {
  description = "Diagnostic setting resource IDs."
  value       = module.cosmosdb.diagnostic_setting_ids
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace resource ID."
  value       = module.log_analytics.id
}

output "log_analytics_workspace_name" {
  description = "Log Analytics Workspace name."
  value       = module.log_analytics.name
}

output "sql_database_ids" {
  description = "Map of Cosmos DB SQL database IDs."
  value       = module.cosmosdb.sql_database_ids
}

output "sql_container_ids" {
  description = "Map of Cosmos DB SQL container IDs."
  value       = module.cosmosdb.sql_container_ids
}

output "private_endpoint_id" {
  description = "Private Endpoint resource ID."
  value       = module.cosmosdb_private_endpoint.private_endpoint_id
}
