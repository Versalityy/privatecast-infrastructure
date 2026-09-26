module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.19.0"

  name          = "vnet-${var.project_name}-dev"
  location      = var.location
  parent_id     = module.resource_group.resource_id
  address_space = var.vnet_address_space
  subnets = {
    server = {
      name             = "snet_server_subnet-${var.project_name}"
      address_prefixes = var.server_subnet_address_for_privatecast
      service_endpoints_with_location = [
        {
          service   = "Microsoft.KeyVault"
          locations = ["*"]
        },
        {
          service   = "Microsoft.Storage"
          locations = ["*"]
        }
      ]


      network_security_group = {

        id = module.avm-res-network-networksecuritygroup.resource_id
      }
    }
  }
  tags = {

    project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

}

