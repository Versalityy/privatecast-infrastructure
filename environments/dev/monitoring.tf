module "avm-res-operationalinsights-workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.5.1"

  name                = "law-${lower(var.project_name)}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name

  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_retention_in_days = 30
  log_analytics_workspace_daily_quota_gb    = 1

  log_analytics_workspace_local_authentication_enabled = false

  log_analytics_workspace_internet_ingestion_enabled = "true"
  log_analytics_workspace_internet_query_enabled     = "true"

  lock = {
    kind = "CanNotDelete"
    name = "lock-law-${lower(var.project_name)}-dev"
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_monitor_data_collection_rule" "privatecast" {
  name                = "dcr-${lower(var.project_name)}-dev"
  resource_group_name = module.resource_group.name
  location            = var.location
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = module.avm-res-operationalinsights-workspace.resource_id
      name                  = "privatecast-log-analytics"
    }
  }

  data_flow {
    streams = [
      "Microsoft-Syslog",
      "Microsoft-Perf"
    ]

    destinations = [
      "privatecast-log-analytics"
    ]
  }

  data_sources {
    syslog {
      name = "privatecast-linux-syslog"

      facility_names = [
        "auth",
        "authpriv",
        "daemon",
        "kern",
        "syslog"
      ]

      log_levels = [
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]

      streams = ["Microsoft-Syslog"]
    }

    performance_counter {
      name                          = "privatecast-linux-performance"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60

      counter_specifiers = [
        "\\Processor(*)\\% Processor Time",
        "\\Memory(*)\\% Used Memory",
        "\\Logical Disk(*)\\% Free Space",
        "\\Logical Disk(*)\\Disk Reads/sec",
        "\\Logical Disk(*)\\Disk Writes/sec",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
    }
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}