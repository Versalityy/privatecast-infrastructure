module "avm-res-recoveryservices-vault" {
  source  = "Azure/avm-res-recoveryservices-vault/azurerm"
  version = "1.2.0"

  name                = "rsv-${lower(var.project_name)}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name
  sku                 = "Standard"

  storage_mode_type = "LocallyRedundant"

  soft_delete_enabled = "AlwaysOn"
  immutability        = "Unlocked"

  public_network_access_enabled = true

  alerts_for_all_job_failures_enabled            = true
  alerts_for_critical_operation_failures_enabled = true

  vm_backup_policy = {
    privatecast_daily = {
      name        = "policy-${lower(var.project_name)}-vm-daily"
      timezone    = "Arab Standard Time"
      policy_type = "V2"
      frequency   = "Daily"

      instant_restore_retention_days = 2

      backup = {
        time = "02:00"
      }

      retention_daily = 7
    }
  }

  backup_protected_vm = {
    privatecast_vm = {
      source_vm_id          = module.avm-res-compute-virtualmachine.resource_id
      vm_backup_policy_name = "policy-${lower(var.project_name)}-vm-daily"
    }
  }

  lock = {
    kind = "CanNotDelete"
    name = "lock-rsv-${lower(var.project_name)}-dev"
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}