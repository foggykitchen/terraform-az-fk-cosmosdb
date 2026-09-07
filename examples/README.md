# Azure Cosmos DB with Terraform/OpenTofu - Training Examples

This directory contains minimal free examples used with the **terraform-az-fk-cosmosdb** module.
The examples are designed as incremental building blocks for private Azure Cosmos DB architectures on Azure.

These examples are part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/) and are meant to be applied independently for learning and experimentation.

---

## Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Private Endpoint** | Cosmos DB SQL API account, SQL database, SQL container, FoggyKitchen Private Endpoint module, Private DNS Zone Group |

---

## How to Use

Each example directory contains:

- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A `terraform.tfvars.example` file with placeholder values

To run an example:

```bash
cd examples/01_private_endpoint
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

The current free learning path contains one minimal example:

```text
01
```

Larger platform compositions belong in FoggyKitchen landing zones or blueprints, not in free module examples.

---

## Design Principles

- One example = one architectural goal
- Cosmos DB is isolated from networking concerns in the root module
- Networking, Private DNS, and Private Endpoints are composed with dedicated FoggyKitchen modules
- Examples avoid hidden dependencies between directories
- Larger platform compositions belong in landing zones or blueprints, not in free module examples

---

## Blueprint Candidates

Advanced Cosmos DB scenarios should be modeled as FoggyKitchen landing zones or blueprints:

- Hub-spoke private Cosmos DB with shared Private DNS
- Cosmos DB behind centralized firewall or inspected egress patterns
- Customer-managed keys with Key Vault and managed identity
- Multi-region account patterns with automatic failover
- Multi-write region patterns for globally distributed applications
- Private application tier consuming Cosmos DB over Private Link

---

## Related Resources

- [FoggyKitchen Azure Cosmos DB Module](../)
- [FoggyKitchen Azure VNet Module](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [FoggyKitchen Azure Private DNS Module](https://github.com/foggykitchen/terraform-az-fk-private-dns)
- [FoggyKitchen Azure Private Endpoint Module](https://github.com/foggykitchen/terraform-az-fk-private-endpoint)
- [FoggyKitchen Azure Compute Module](https://github.com/foggykitchen/terraform-az-fk-compute)

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
