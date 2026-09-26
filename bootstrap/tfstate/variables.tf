variable "subscription_id" {
  description = "id used to create terraform backend"
  type        = string
}

variable "location" {
  description = "region used for terraform backend"
  type        = string
}

variable "project_name" {
  description = "name used for terraform backend"
  type        = string
}

variable "storage_account_name" {
  description = "storage account name used to terraform backend"
  type        = string


  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must contain 3-24 lowercase letters or numbers only."
  }
}

variable "allowed_backend_ip" {
  description = "The single public IPv4 address allowed to access the Terraform state storage account."
  type        = string

  validation {
    condition = (
      !can(regex("/", var.allowed_backend_ip)) &&
      can(cidrhost("${var.allowed_backend_ip}/32", 0))
    )

    error_message = "The backend IP must be a single valid IPv4 address without /32, such as 1.2.3.4."
  }
}

variable "terraform_principal_object_id" {
  description = "The Microsoft Entra object ID granted access to the Terraform state container."
  type        = string
}