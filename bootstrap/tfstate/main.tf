module "avm-res-resources-resourcegroup" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.4.0"
  name     = "rg-${var.project_name}-tfstate"
  location = var.location

  tags = {
    Project     = "var.project_name"
    Environment = "shared"
    ManagedBy   = "terraform"
    purpose     = "Terraform-tfstate"

  }

}
module "avm-res-storage-storageaccount" {
  source    = "Azure/avm-res-storage-storageaccount/azurerm"
  version   = "0.7.3"
  name      = var.storage_account_name
  parent_id = module.avm-res-resources-resourcegroup.resource_id
  location  = var.location


  account_kind                     = "StorageV2"
  account_sku_name                 = "Standard_LRS"
  access_tier                      = "Hot"
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
    ip_rules       = [var.allowed_backend_ip]
  }

  blob_properties = {
    versioning_enabled = true

    delete_retention_policy = {
      enabled                = true
      days                   = 14
      allow_permanent_delete = false
    }

    container_delete_retention_policy = {
      enabled                = true
      days                   = 14
      allow_permanent_delete = false
    }
  }

  containers = {
    tfstate = {
      name          = "tfstate"
      public_access = "None"

      role_assignments = {
        terraform_operator = {
          role_definition_id_or_name = "Storage Blob Data Contributor"
          principal_id               = var.terraform_principal_object_id
          principal_type             = "User"
          description                = "Allows the Terraform operator to manage remote state blobs."
        }
      }
    }
  }

  lock = {
    name = "lock-privatecast-tfstate"
    kind = "CanNotDelete"
  }

  tags = {
    Project     = var.project_name
    Environment = "shared"
    Purpose     = "Terraform-State"
    ManagedBy   = "Terraform"
  }
}









