variable "subscription_id" {
  description = "azure subscription id used for infra"
  type        = string
}

variable "location" {
  description = "this is the location for resources"
  type        = string
}

variable "project_name" {
  description = "this is the project name "
  type        = string
}

variable "vnet_address_space" {
  description = "this is the address space for the vnet "
  type        = set(string)
}

variable "server_subnet_address_for_privatecast" {
  description = "subnet address space for privatecast "
  type        = list(string)
}

variable "allowed_ssh_ip" {
  description = "public ip allowed to ssh to vm "
  type        = string
}

variable "ssh_public_key_path" {
  description = "The local path to the SSH"
  type        = string
}

variable "vm_size" {
  description = "The size of the Privatecast vm"
  type        = string
}

variable "vm_admin_username" {
  description = "The administrator user name for the privatecast vm"
  type        = string
}

variable "vm_zone" {
  description = "vm zone for privatecast "
  type        = string
}

variable "key_vault_name" {
  description = "The globally unique name for key vault"
  type        = string

  validation {
    condition = (
      length(var.key_vault_name) >= 3 &&
      length(var.key_vault_name) <= 24 &&
      can(regex("^[A-Za-z][A-Za-z0-9-]*[A-Za-z0-9]$", var.key_vault_name)) &&
      !strcontains(var.key_vault_name, "--")
    )
    error_message = "The Key Vault name must be 3-24 characters, start with a letter, end with a letter or number, and contain only letters, numbers, and single hyphens."
  }
}

variable "alert_email_address" {
  description = "Email address that receives PrivateCast infra alert"
  type        = string
}

variable "monthly_budget_amount" {
  description = "monthly azure budget for the PrivateCast Env"
  type        = number
}

variable "budget_start_date" {
  description = "Start date of the Azure monthly budget. Must be the first day of a month"
  type        = string
}

variable "sqlite_backup_storage_account_name" {
  description = "Globally unique storage account name used for PrivateCast SQLite backups."
  type        = string

  validation {
    condition = can(regex(
      "^[a-z0-9]{3,24}$",
      var.sqlite_backup_storage_account_name
    ))

    error_message = "The SQLite backup storage account name must contain 3-24 lowercase letters or numbers only."
  }
}