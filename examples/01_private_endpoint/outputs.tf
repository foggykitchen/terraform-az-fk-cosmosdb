output "cosmosdb_account_id" {
  description = "Cosmos DB account resource ID."
  value       = module.cosmosdb.id
}

output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint."
  value       = module.cosmosdb.endpoint
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
