module "avm-res-compute-virtualmachine" {
  source              = "Azure/avm-res-compute-virtualmachine/azurerm"
  version             = "0.21.0"
  name                = "vm-${lower(var.project_name)}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name
  zone                = var.vm_zone


  os_type  = "Linux"
  sku_size = var.vm_size

  secure_boot_enabled = true
  vtpm_enabled        = true

  patch_assessment_mode = "AutomaticByPlatform"
  patch_mode            = "AutomaticByPlatform"
  provision_vm_agent    = true

  source_image_reference = {

    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml.tftpl", {
    admin_username = var.vm_admin_username
  }))

  account_credentials = {
    admin_credentials = {
      username                           = var.vm_admin_username
      ssh_keys                           = [file(pathexpand(var.ssh_public_key_path))]
      generate_admin_password_or_ssh_key = false


      password_authentication_disabled = true
    }
  }
  network_interfaces = {
    primary = {
      name       = "nic-${lower(var.project_name)}-dev"
      is_primary = true

      accelerated_networking_enabled = false

      ip_configurations = {
        primary = {
          name                          = "ipconfig-primary"
          private_ip_address_allocation = "Dynamic"
          private_ip_subnet_resource_id = module.virtual_network.subnets["server"].resource_id
          public_ip_address_resource_id = module.avm-res-network-publicipaddress.resource_id
          is_primary_ipconfiguration    = true
        }
      }
    }
  }


  os_disk = {
    name                 = "os-disk-${lower(var.project_name)}-dev"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 32


  }
  encryption_at_host_enabled = false
  shutdown_schedules = {
    daily = {
      daily_recurrence_time = "0100"
      timezone              = "Arab Standard Time"
      enabled               = true

      notification_settings = {
        enabled = false
      }
    }
  }

  managed_identities = {
    system_assigned = true
  }
  extensions = {
    azure_monitor_agent = {
      name                       = "AzureMonitorForLinuxAgent"
      publisher                  = "Microsoft.Azure.Monitor"
      type                       = "AzureMonitorLinuxAgent"
      type_handler_version       = "1.0"
      auto_upgrade_minor_version = true
      automatic_upgrade_enabled  = true
    }
  }
  tags = {
    project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

}

resource "azurerm_monitor_data_collection_rule_association" "privatecast_vm" {
  name                    = "dcra-${lower(var.project_name)}-dev"
  target_resource_id      = module.avm-res-compute-virtualmachine.resource_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.privatecast.id

  description = "Associates the PrivateCast Linux VM with its monitoring data collection rule."
}