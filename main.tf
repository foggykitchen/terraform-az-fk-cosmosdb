resource "azurerm_cosmosdb_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  offer_type                            = var.offer_type
  kind                                  = var.kind
  minimal_tls_version                   = var.minimal_tls_version
  free_tier_enabled                     = var.free_tier_enabled
  analytical_storage_enabled            = var.analytical_storage_enabled
  automatic_failover_enabled            = var.automatic_failover_enabled
  multiple_write_locations_enabled      = var.multiple_write_locations_enabled
  partition_merge_enabled               = var.partition_merge_enabled
  burst_capacity_enabled                = var.burst_capacity_enabled
  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  ip_range_filter                       = var.ip_range_filter
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids
  local_authentication_enabled          = var.local_authentication_enabled
  key_vault_key_id                      = var.key_vault_key_id
  default_identity_type                 = var.default_identity_type
  tags                                  = var.tags

  consistency_policy {
    consistency_level       = var.consistency_policy.consistency_level
    max_interval_in_seconds = var.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy.max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = var.geo_locations

    content {
      location          = geo_location.key
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities

    content {
      name = capabilities.value
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rules

    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "analytical_storage" {
    for_each = var.analytical_storage == null ? [] : [var.analytical_storage]

    content {
      schema_type = analytical_storage.value.schema_type
    }
  }

  dynamic "capacity" {
    for_each = var.capacity == null ? [] : [var.capacity]

    content {
      total_throughput_limit = capacity.value.total_throughput_limit
    }
  }

  dynamic "backup" {
    for_each = var.backup == null ? [] : [var.backup]

    content {
      type                = backup.value.type
      tier                = backup.value.tier
      interval_in_minutes = backup.value.interval_in_minutes
      retention_in_hours  = backup.value.retention_in_hours
      storage_redundancy  = backup.value.storage_redundancy
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  lifecycle {
    precondition {
      condition     = length([for _, geo_location in var.geo_locations : geo_location if geo_location.failover_priority == 0]) == 1
      error_message = "geo_locations must contain exactly one location with failover_priority 0."
    }

    precondition {
      condition     = var.public_network_access_enabled || length(var.ip_range_filter) == 0
      error_message = "ip_range_filter can be used only when public_network_access_enabled is true."
    }

    precondition {
      condition     = !var.is_virtual_network_filter_enabled || length(var.virtual_network_rules) > 0
      error_message = "virtual_network_rules are required when is_virtual_network_filter_enabled is true."
    }
  }
}

resource "azurerm_cosmosdb_sql_database" "this" {
  for_each = var.sql_databases

  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = each.value.throughput

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings == null ? [] : [each.value.autoscale_settings]

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  lifecycle {
    precondition {
      condition     = !(each.value.throughput != null && each.value.autoscale_settings != null)
      error_message = "Set either throughput or autoscale_settings for a SQL database, not both."
    }
  }
}

resource "azurerm_cosmosdb_sql_container" "this" {
  for_each = var.sql_containers

  name                   = each.key
  resource_group_name    = var.resource_group_name
  account_name           = azurerm_cosmosdb_account.this.name
  database_name          = each.value.database_name
  partition_key_paths    = each.value.partition_key_paths
  partition_key_kind     = each.value.partition_key_kind
  partition_key_version  = each.value.partition_key_version
  throughput             = each.value.throughput
  default_ttl            = each.value.default_ttl
  analytical_storage_ttl = each.value.analytical_storage_ttl

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings == null ? [] : [each.value.autoscale_settings]

    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  dynamic "conflict_resolution_policy" {
    for_each = each.value.conflict_resolution_mode == null ? [] : [each.value]

    content {
      mode                          = conflict_resolution_policy.value.conflict_resolution_mode
      conflict_resolution_path      = conflict_resolution_policy.value.conflict_resolution_path
      conflict_resolution_procedure = conflict_resolution_policy.value.conflict_resolution_procedure
    }
  }

  dynamic "indexing_policy" {
    for_each = each.value.indexing_policy == null ? [] : [each.value.indexing_policy]

    content {
      indexing_mode = indexing_policy.value.indexing_mode

      dynamic "included_path" {
        for_each = indexing_policy.value.included_paths

        content {
          path = included_path.value.path
        }
      }

      dynamic "excluded_path" {
        for_each = indexing_policy.value.excluded_paths

        content {
          path = excluded_path.value.path
        }
      }

      dynamic "composite_index" {
        for_each = indexing_policy.value.composite_indexes

        content {
          dynamic "index" {
            for_each = composite_index.value

            content {
              path  = index.value.path
              order = index.value.order
            }
          }
        }
      }
    }
  }

  dynamic "unique_key" {
    for_each = each.value.unique_keys

    content {
      paths = unique_key.value.paths
    }
  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.sql_databases), each.value.database_name)
      error_message = "Each SQL container database_name must refer to a key in sql_databases."
    }

    precondition {
      condition     = !(each.value.throughput != null && each.value.autoscale_settings != null)
      error_message = "Set either throughput or autoscale_settings for a SQL container, not both."
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name
  target_resource_id             = azurerm_cosmosdb_account.this.id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  log_analytics_destination_type = each.value.log_analytics_workspace_id == null ? null : each.value.log_analytics_destination_type
  storage_account_id             = each.value.storage_account_id
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  eventhub_name                  = each.value.eventhub_name

  dynamic "enabled_log" {
    for_each = toset(coalesce(each.value.log_categories, [
      "DataPlaneRequests",
      "QueryRuntimeStatistics",
      "PartitionKeyStatistics",
      "PartitionKeyRUConsumption",
      "ControlPlaneRequests"
    ]))

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(each.value.metric_categories)

    content {
      category = enabled_metric.value
    }
  }
}
