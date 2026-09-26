module "resource_group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.4.0"
  name     = "rg${var.project_name}-dev"
  location = var.location

  tags = {

    project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"

  }
}