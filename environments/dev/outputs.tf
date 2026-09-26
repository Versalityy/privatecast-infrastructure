output "resource_group_name" {
  description = "The name of the PrivateCast resource group."
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "The resource id of the PrivateCast resource group."
  value       = module.resource_group.resource_id
}

output "resource_group_location" {
  description = "The Azure location of the PrivateCast resource group."
  value       = module.resource_group.location
}

output "virtual_network_name" {
  description = "The name of the private cast vnet"
  value       = module.virtual_network.name
}

output "virtual_network_resource_id" {
  description = "the Resource id of the private cast vnet"
  value       = module.virtual_network.resource_id
}

output "server_subnet_name" {
  description = "This is the subnet name for privatecast"
  value       = module.virtual_network.subnets["server"].name
}

output "server_subnet_id" {
  description = ""
  value       = module.virtual_network.subnets["server"].resource_id
}

output "network_security_group_name" {
  description = "The name of the PrivateCast nsg"
  value       = module.avm-res-network-networksecuritygroup.name
}

output "network_security_group_resource_id" {
  description = "The resource id of the privatecast nsg"
  value       = module.avm-res-network-networksecuritygroup.resource_id
}

output "public_ip_address" {
  description = "The public IP address assigned to the PrivateCast VM."
  value       = module.avm-res-network-publicipaddress.public_ip_address
}

output "public_ip_resource_id" {
  description = "The resource ID of the PrivateCast public IP."
  value       = module.avm-res-network-publicipaddress.resource_id
}

output "virtual_machine_resource_id" {
  description = "The resource ID of the PrivateCast virtual machine."
  value       = module.avm-res-compute-virtualmachine.resource_id
}

output "virtual_machine_managed_identity_principal_id" {
  description = "The principal ID of the system-assigned managed identity attached to the PrivateCast VM."
  value       = module.avm-res-compute-virtualmachine.system_assigned_mi_principal_id
}

output "key_vault_name" {
  description = "The name of the PrivateCast Azure Key Vault."
  value       = module.avm-res-keyvault-vault.name
}

output "key_vault_resource_id" {
  description = "The resource ID of the PrivateCast Azure Key Vault."
  value       = module.avm-res-keyvault-vault.resource_id
}

output "key_vault_uri" {
  description = "The URI used by PrivateCast workloads to access Azure Key Vault."
  value       = module.avm-res-keyvault-vault.uri
}

output "log_analytics_workspace_resource_id" {
  description = "The resource ID of the PrivateCast Log Analytics workspace."
  value       = module.avm-res-operationalinsights-workspace.resource_id
}

output "recovery_services_vault_resource_id" {
  description = "The resource ID of the PrivateCast Recovery Services Vault."
  value       = module.avm-res-recoveryservices-vault.resource_id
}

output "sqlite_backup_storage_account_name" {
  description = "The name of the storage account used for PrivateCast SQLite backups."
  value       = module.avm-res-storage-sqlite-backup.name
}

output "sqlite_backup_storage_account_resource_id" {
  description = "The resource ID of the storage account used for PrivateCast SQLite backups."
  value       = module.avm-res-storage-sqlite-backup.resource_id
}