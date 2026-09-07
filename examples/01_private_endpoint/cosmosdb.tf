module "cosmosdb" {
  source = "../../"

  name                = "${var.name_prefix}-acct"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  public_network_access_enabled = false

  geo_locations = {
    (azurerm_resource_group.foggykitchen_rg.location) = {
      failover_priority = 0
      zone_redundant    = false
    }
  }

  consistency_policy = {
    consistency_level = "Session"
  }

  sql_databases = {
    foggydb = {
      throughput = 400
    }
  }

  sql_containers = {
    items = {
      database_name         = "foggydb"
      partition_key_paths   = ["/partitionKey"]
      partition_key_version = 2

      indexing_policy = {
        indexing_mode = "consistent"
        included_paths = [
          {
            path = "/*"
          }
        ]
      }
    }
  }

  tags = var.tags
}

module "cosmosdb_private_endpoint" {
  source = "github.com/foggykitchen/terraform-az-fk-private-endpoint"

  name                = "${var.name_prefix}-pe"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  subnet_id                      = module.vnet.subnet_ids["fk-subnet-private-endpoint"]
  private_connection_resource_id = module.cosmosdb.id
  subresource_names              = ["Sql"]
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids = [
    module.private_dns.private_dns_zone_ids["privatelink.documents.azure.com"]
  ]

  tags = var.tags

  depends_on = [
    module.private_dns
  ]
}
