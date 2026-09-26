data "azurerm_client_config" "current" {}

module "avm-res-keyvault-vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"

  name                = var.key_vault_name
  location            = var.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 14


  public_network_access_enabled = true

  network_acls = {
    bypass         = "None"
    default_action = "Deny"

    ip_rules = [
      var.allowed_ssh_ip
    ]

    virtual_network_subnet_ids = [
      module.virtual_network.subnets["server"].resource_id
    ]
  }

  role_assignments = {
    vm_secret_reader = {
      role_definition_id_or_name = "Key Vault Secrets User"
      principal_id               = module.avm-res-compute-virtualmachine.system_assigned_mi_principal_id
      principal_type             = "ServicePrincipal"
      description                = "Allows the PrivateCast VM to read secrets at runtime."
    }
  }
  lock = {
    kind = "CanNotDelete"
    name = "lock-${var.key_vault_name}"
  }

  tags = {
    project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"

  }

}