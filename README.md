# terraform-az-fk-cosmosdb

This repository contains a reusable **Terraform/OpenTofu module** and progressive examples for deploying **Azure Cosmos DB** accounts with SQL API databases and containers.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** and is designed as a clean, composable database layer that integrates with existing Azure networking foundations such as VNets, Private DNS Zones, and Private Endpoints.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Used By

This module is intended to be used as a building block by higher-level FoggyKitchen examples and landing zone patterns where Cosmos DB is consumed privately by application workloads.

## Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for Azure Cosmos DB:

- Focused on Cosmos DB account, SQL API databases, and SQL API containers
- No hidden networking resources or implicit assumptions
- Designed to integrate cleanly with:
  - Azure VNets
  - Private DNS Zones
  - Private Endpoints
  - IP firewall rules for controlled public access scenarios
  - VNet service endpoint rules
  - Optional managed identity and customer-managed key inputs

This is **not** a full Landing Zone or opinionated platform module.
It is a **learning-first, architecture-aware module**.

---

## What the module does

Depending on configuration and example used, the module can create:

- Azure Cosmos DB account
- Optional Cosmos DB SQL databases
- Optional Cosmos DB SQL containers
- Optional account capabilities
- Optional virtual network service endpoint rules
- Optional CORS rules
- Optional managed identity assignment
- Public or Private Endpoint integration patterns when composed with other FoggyKitchen modules

The module intentionally does not create:

- Resource groups
- Virtual Networks or subnets
- Private DNS Zones
- Private Endpoints
- Network Security Groups
- Bastion hosts or validation clients
- Application data, stored procedures, triggers, or seed data

Each of those concerns belongs in its own dedicated module or example layer.

---

## Repository Structure

```text
terraform-az-fk-cosmosdb/
├── examples/
│   ├── 01_private_endpoint/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
├── SUPPORT.md
└── README.md
```

---

## Example Usage

```hcl
module "cosmosdb" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-cosmosdb.git?ref=v0.1.0"

  name                = "fk-cosmos-dev"
  location            = "westeurope"
  resource_group_name = "fk-rg-dev"

  public_network_access_enabled = false

  geo_locations = {
    westeurope = {
      failover_priority = 0
    }
  }

  sql_databases = {
    foggydb = {
      throughput = 400
    }
  }

  sql_containers = {
    items = {
      database_name       = "foggydb"
      partition_key_paths = ["/partitionKey"]
    }
  }

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

For Private Endpoint patterns, compose this module with `terraform-az-fk-private-endpoint` using subresource `Sql` and Private DNS Zone `privatelink.documents.azure.com`.

---

## Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | `string` | Yes | Cosmos DB account name |
| `location` | `string` | Yes | Azure region |
| `resource_group_name` | `string` | Yes | Resource Group name |
| `geo_locations` | `map(object)` | Yes | Cosmos DB account replication locations |
| `offer_type` | `string` | No | Cosmos DB account offer type |
| `kind` | `string` | No | Cosmos DB account kind |
| `minimal_tls_version` | `string` | No | Minimum TLS version |
| `consistency_policy` | `object` | No | Cosmos DB consistency policy |
| `free_tier_enabled` | `bool` | No | Enable free tier |
| `analytical_storage_enabled` | `bool` | No | Enable analytical storage |
| `automatic_failover_enabled` | `bool` | No | Enable automatic failover |
| `multiple_write_locations_enabled` | `bool` | No | Enable multiple write locations |
| `partition_merge_enabled` | `bool` | No | Enable partition merge |
| `burst_capacity_enabled` | `bool` | No | Enable burst capacity |
| `public_network_access_enabled` | `bool` | No | Enable public network access |
| `is_virtual_network_filter_enabled` | `bool` | No | Enable VNet service endpoint filtering |
| `ip_range_filter` | `set(string)` | No | Allowed public IP CIDR ranges |
| `network_acl_bypass_for_azure_services` | `bool` | No | Allow Azure services to bypass ACLs |
| `network_acl_bypass_ids` | `set(string)` | No | Resource IDs allowed to bypass ACLs |
| `local_authentication_enabled` | `bool` | No | Enable local key-based authentication |
| `key_vault_key_id` | `string` | No | Key Vault key ID for customer-managed encryption |
| `default_identity_type` | `string` | No | Default identity used for Key Vault access |
| `capabilities` | `set(string)` | No | Cosmos DB account capabilities |
| `virtual_network_rules` | `map(object)` | No | VNet service endpoint access rules |
| `analytical_storage` | `object` | No | Analytical storage configuration |
| `capacity` | `object` | No | Account throughput capacity limit |
| `backup` | `object` | No | Backup policy |
| `cors_rules` | `map(object)` | No | CORS rules |
| `identity` | `object` | No | Managed identity assigned to the account |
| `sql_databases` | `map(object)` | No | Cosmos DB SQL databases to create |
| `sql_containers` | `map(object)` | No | Cosmos DB SQL containers to create |
| `tags` | `map(string)` | No | Resource tags |

### SQL database object schema

```hcl
sql_databases = map(object({
  throughput = optional(number)
  autoscale_settings = optional(object({
    max_throughput = optional(number)
  }))
}))
```

### SQL container object schema

```hcl
sql_containers = map(object({
  database_name                  = string
  partition_key_paths            = list(string)
  partition_key_kind             = optional(string, "Hash")
  partition_key_version          = optional(number, 2)
  throughput                     = optional(number)
  default_ttl                    = optional(number)
  analytical_storage_ttl         = optional(number)
  conflict_resolution_mode       = optional(string)
  conflict_resolution_path       = optional(string)
  conflict_resolution_procedure  = optional(string)
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
```

---

## Outputs

| Output | Description |
|--------|-------------|
| `id` | Cosmos DB account resource ID |
| `name` | Cosmos DB account name |
| `endpoint` | Cosmos DB account endpoint |
| `read_endpoints` | Cosmos DB read endpoints |
| `write_endpoints` | Cosmos DB write endpoints |
| `primary_sql_connection_string` | Primary SQL API connection string |
| `sql_database_ids` | Map of SQL database resource IDs keyed by database name |
| `sql_container_ids` | Map of SQL container resource IDs keyed by container name |

---

## Examples Overview

| Example | Description |
|---------|-------------|
| `01_private_endpoint` | Cosmos DB SQL API account, database, and container composed with Azure Private Endpoint and Private DNS Zone Group |

See [`examples/`](examples) for details.

Free examples are intentionally minimal. More complete platform patterns such as hub-spoke private Cosmos DB, centralized inspection, customer-managed keys, or multi-region account topologies should live as FoggyKitchen landing zones or blueprints.

---

## Design Philosophy

- Cosmos DB is a data service, not a networking module
- Private connectivity is explicit and composed from separate FoggyKitchen modules
- Cosmos DB private access is modeled with Private Endpoint and Private DNS
- SQL API databases and containers are exposed as simple maps
- Outputs expose IDs and endpoints needed by higher-level application modules
- Defaults are suitable for training and development, not production policy enforcement

---

## Related Modules & Training

- [terraform-az-fk-vnet](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [terraform-az-fk-private-dns](https://github.com/foggykitchen/terraform-az-fk-private-dns)
- [terraform-az-fk-private-endpoint](https://github.com/foggykitchen/terraform-az-fk-private-endpoint)
- [terraform-az-fk-compute](https://github.com/foggykitchen/terraform-az-fk-compute)
- [terraform-az-fk-nsg](https://github.com/foggykitchen/terraform-az-fk-nsg)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
