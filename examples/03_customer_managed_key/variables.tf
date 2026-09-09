variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Name prefix for example resources."
  type        = string
  default     = "fk-cosmos03"
}

variable "vnet_address_space" {
  description = "VNet address space."
  type        = string
  default     = "10.80.0.0/16"
}

variable "key_vault_key_name" {
  description = "Key Vault key name used for Cosmos DB customer-managed encryption."
  type        = string
  default     = "cosmosdb-cmk"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    project     = "foggykitchen"
    environment = "dev"
    managed_by  = "opentofu"
  }
}
