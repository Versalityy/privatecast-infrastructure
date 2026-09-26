module "avm-res-storage-sqlite-backup" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.7.3"

  name      = var.sqlite_backup_storage_account_name
  location  = var.location
  parent_id = module.resource_group.resource_id

  account_kind     = "StorageV2"
  account_sku_name = "Standard_LRS"
  access_tier      = "Hot"

  min_tls_version                  = "TLS1_2"
  https_traffic_only_enabled       = true
  shared_access_key_enabled        = false
  default_to_oauth_authentication  = true
  public_network_access_enabled    = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  network_rules = {
    default_action = "Deny"
    bypass         = ["AzureServices"]

    virtual_network_subnet_ids = [
      module.virtual_network.subnets["server"].resource_id
    ]
  }

  blob_properties = {
    versioning_enabled = true

    delete_retention_policy = {
      enabled                = true
      days                   = 7
      allow_permanent_delete = false
    }

    container_delete_retention_policy = {
      enabled                = true
      days                   = 7
      allow_permanent_delete = false
    }
  }

  containers = {
    sqlite_backups = {
      name          = "sqlite-backups"
      public_access = "None"

      role_assignments = {
        vm_backup_writer = {
          role_definition_id_or_name = "Storage Blob Data Contributor"
          principal_id               = module.avm-res-compute-virtualmachine.system_assigned_mi_principal_id
          principal_type             = "ServicePrincipal"

          description = "Allows the PrivateCast VM to upload and manage SQLite backups."
        }
      }
    }
  }

  storage_management_policy_rule = {
    delete_old_sqlite_backups = {
      name    = "delete-old-sqlite-backups"
      enabled = true

      filters = {
        blob_types = ["blockBlob"]

        prefix_match = [
          "sqlite-backups/"
        ]
      }

      actions = {
        base_blob = {
          delete_after_days_since_creation_greater_than = 14
        }

        version = {
          delete_after_days_since_creation = 14
        }
      }
    }
  }

  lock = {
    kind = "CanNotDelete"
    name = "lock-${var.sqlite_backup_storage_account_name}"
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    Purpose     = "SQLite-Backup"
    ManagedBy   = "Terraform"
  }
}