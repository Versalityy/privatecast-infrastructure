module "avm-res-network-publicipaddress" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.2.1"

  name                = "pip-${lower(var.project_name)}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name


  allocation_method = "Static"
  sku               = "Standard"
  ip_version        = "IPv4"
  tags = {
    project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}





