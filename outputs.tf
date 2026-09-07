output "id" {
  description = "Cosmos DB account resource ID."
  value       = azurerm_cosmosdb_account.this.id
}

output "name" {
  description = "Cosmos DB account name."
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "Cosmos DB account endpoint."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "read_endpoints" {
  description = "Cosmos DB account read endpoints."
  value       = azurerm_cosmosdb_account.this.read_endpoints
}

output "write_endpoints" {
  description = "Cosmos DB account write endpoints."
  value       = azurerm_cosmosdb_account.this.write_endpoints
}

output "primary_sql_connection_string" {
  description = "Primary SQL API connection string."
  value       = azurerm_cosmosdb_account.this.primary_sql_connection_string
  sensitive   = true
}

output "sql_database_ids" {
  description = "Map of SQL database resource IDs keyed by database name."
  value = {
    for database_name, database in azurerm_cosmosdb_sql_database.this :
    database_name => database.id
  }
}

output "sql_container_ids" {
  description = "Map of SQL container resource IDs keyed by container name."
  value = {
    for container_name, container in azurerm_cosmosdb_sql_container.this :
    container_name => container.id
  }
}
