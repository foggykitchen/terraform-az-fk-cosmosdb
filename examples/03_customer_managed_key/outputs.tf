output "cosmosdb_account_id" {
  description = "Cosmos DB account resource ID."
  value       = module.cosmosdb.id
}

output "cosmosdb_account_name" {
  description = "Cosmos DB account name."
  value       = module.cosmosdb.name
}

output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint."
  value       = module.cosmosdb.endpoint
}

output "cmk_enabled" {
  description = "Whether customer-managed key encryption is enabled."
  value       = module.cosmosdb.cmk_enabled
}

output "cmk_identity_id" {
  description = "User-assigned managed identity resource ID."
  value       = module.cosmosdb_cmk_identity.id
}

output "cmk_identity_principal_id" {
  description = "User-assigned managed identity principal ID."
  value       = module.cosmosdb_cmk_identity.principal_id
}

output "cmk_identity_client_id" {
  description = "User-assigned managed identity client ID."
  value       = module.cosmosdb_cmk_identity.client_id
}

output "key_vault_id" {
  description = "Key Vault resource ID."
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = module.key_vault.key_vault_name
}

output "key_vault_key_id" {
  description = "Versionless Key Vault key ID used for Cosmos DB customer-managed encryption."
  value       = module.cosmosdb_cmk_key.versionless_id
}

output "key_vault_key_resource_id" {
  description = "Versionless Azure resource ID of the Key Vault key used for Cosmos DB customer-managed encryption."
  value       = module.cosmosdb_cmk_key.resource_versionless_id
}

output "key_vault_current_user_role_assignment_id" {
  description = "Key Vault RBAC role assignment ID for the principal running OpenTofu."
  value       = module.key_vault_current_user_crypto_officer.role_assignment_id
}

output "key_vault_role_assignment_id" {
  description = "Key Vault RBAC role assignment ID for the Cosmos DB CMK identity."
  value       = module.cosmosdb_cmk_rbac.role_assignment_id
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
