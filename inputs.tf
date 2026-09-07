variable "name" {
  description = "Azure Cosmos DB account name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "offer_type" {
  description = "Cosmos DB account offer type."
  type        = string
  default     = "Standard"

  validation {
    condition     = var.offer_type == "Standard"
    error_message = "offer_type must be Standard."
  }
}

variable "kind" {
  description = "Cosmos DB account kind."
  type        = string
  default     = "GlobalDocumentDB"

  validation {
    condition     = contains(["GlobalDocumentDB", "MongoDB", "Parse"], var.kind)
    error_message = "kind must be one of: GlobalDocumentDB, MongoDB, Parse."
  }
}

variable "minimal_tls_version" {
  description = "Minimum TLS version for the Cosmos DB account."
  type        = string
  default     = "Tls12"

  validation {
    condition     = var.minimal_tls_version == "Tls12"
    error_message = "minimal_tls_version must be Tls12."
  }
}

variable "geo_locations" {
  description = "Cosmos DB replication locations. Exactly one location must use failover_priority 0."
  type = map(object({
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
}

variable "consistency_policy" {
  description = "Cosmos DB account consistency policy."
  type = object({
    consistency_level       = optional(string, "Session")
    max_interval_in_seconds = optional(number)
    max_staleness_prefix    = optional(number)
  })
  default = {}

  validation {
    condition = contains(
      ["BoundedStaleness", "Eventual", "Session", "Strong", "ConsistentPrefix"],
      var.consistency_policy.consistency_level
    )
    error_message = "consistency_policy.consistency_level must be one of: BoundedStaleness, Eventual, Session, Strong, ConsistentPrefix."
  }
}

variable "free_tier_enabled" {
  description = "Enable the Cosmos DB free tier pricing option."
  type        = bool
  default     = false
}

variable "analytical_storage_enabled" {
  description = "Enable analytical storage for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "multiple_write_locations_enabled" {
  description = "Enable multiple write locations for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "partition_merge_enabled" {
  description = "Enable partition merge for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "burst_capacity_enabled" {
  description = "Enable burst capacity for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access. Set false for Private Endpoint-only patterns."
  type        = bool
  default     = true
}

variable "is_virtual_network_filter_enabled" {
  description = "Enable virtual network filtering for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "ip_range_filter" {
  description = "Allowed public IP ranges in CIDR notation."
  type        = set(string)
  default     = []
}

variable "network_acl_bypass_for_azure_services" {
  description = "Allow Azure services to bypass network ACLs."
  type        = bool
  default     = false
}

variable "network_acl_bypass_ids" {
  description = "Resource IDs allowed to bypass network ACLs."
  type        = set(string)
  default     = []
}

variable "local_authentication_enabled" {
  description = "Enable local key-based authentication for SQL API accounts."
  type        = bool
  default     = true
}

variable "key_vault_key_id" {
  description = "Optional versionless Key Vault key ID for customer-managed encryption."
  type        = string
  default     = null
}

variable "default_identity_type" {
  description = "Default identity used by Cosmos DB, for example FirstPartyIdentity or UserAssignedIdentity=<identity_id>."
  type        = string
  default     = null
}

variable "capabilities" {
  description = "Cosmos DB account capabilities to enable."
  type        = set(string)
  default     = []
}

variable "virtual_network_rules" {
  description = "Map of virtual network rules for service endpoint access."
  type = map(object({
    id                                   = string
    ignore_missing_vnet_service_endpoint = optional(bool, false)
  }))
  default = {}
}

variable "analytical_storage" {
  description = "Optional analytical storage configuration."
  type = object({
    schema_type = string
  })
  default = null
}

variable "capacity" {
  description = "Optional account throughput capacity limit."
  type = object({
    total_throughput_limit = number
  })
  default = null
}

variable "backup" {
  description = "Optional backup policy."
  type = object({
    type                = string
    tier                = optional(string)
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
    storage_redundancy  = optional(string)
  })
  default = null
}

variable "cors_rules" {
  description = "Cosmos DB CORS rules."
  type = map(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = optional(number)
  }))
  default = {}
}

variable "identity" {
  description = "Optional managed identity assigned to the Cosmos DB account."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "sql_databases" {
  description = "Map of Cosmos DB SQL databases to create."
  type = map(object({
    throughput = optional(number)
    autoscale_settings = optional(object({
      max_throughput = optional(number)
    }))
  }))
  default = {}
}

variable "sql_containers" {
  description = "Map of Cosmos DB SQL containers to create."
  type = map(object({
    database_name                 = string
    partition_key_paths           = list(string)
    partition_key_kind            = optional(string, "Hash")
    partition_key_version         = optional(number, 2)
    throughput                    = optional(number)
    default_ttl                   = optional(number)
    analytical_storage_ttl        = optional(number)
    conflict_resolution_mode      = optional(string)
    conflict_resolution_path      = optional(string)
    conflict_resolution_procedure = optional(string)
    autoscale_settings = optional(object({
      max_throughput = optional(number)
    }))
    indexing_policy = optional(object({
      indexing_mode = optional(string, "consistent")
      included_paths = optional(list(object({
        path = string
      })), [])
      excluded_paths = optional(list(object({
        path = string
      })), [])
      composite_indexes = optional(list(list(object({
        path  = string
        order = string
      }))), [])
    }))
    unique_keys = optional(list(object({
      paths = list(string)
    })), [])
  }))
  default = {}
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
