module "avm-res-network-networksecuritygroup" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  name                = "nsg-${var.project_name}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name

  security_rules = {
    allow_http = {
      name                       = "Allow-HTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    allow_https = {

      name                       = "Allow-HTTPS"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    allow_livekit_tcp = {

      name                       = "Allow-Livekit-TCP"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "7881"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"

    }
    allow_livekit_turn_udp = {
      name                       = "Allow-Livekit-TURN-UDP"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "3478"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    allow_livekit_media_udp = {
      name                       = "Allow-Livekit-Media-UDP"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "50000-60000"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"


    }
    allow_ssh_from_admin = {
      name                       = "Allow-SSH-From-Admin"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = var.allowed_ssh_ip
      destination_address_prefix = "*"
    }

  }

  tags = {
    project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}