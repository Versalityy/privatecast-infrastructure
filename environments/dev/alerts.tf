resource "azurerm_monitor_action_group" "privatecast" {
  name                = "ag-${lower(var.project_name)}-dev"
  resource_group_name = module.resource_group.name
  short_name          = "pcdevalerts"

  email_receiver {
    name                    = "privatecast-admin"
    email_address           = var.alert_email_address
    use_common_alert_schema = true
  }
  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

}

resource "azurerm_monitor_metric_alert" "vm_high_cpu" {
  name                = "alert-${lower(var.project_name)}-vm-high-cpu"
  resource_group_name = module.resource_group.name
  scopes              = [module.avm-res-compute-virtualmachine.resource_id]

  description = "Alerts when the PrivateCast VM average CPU usage exceeds 80 percent."

  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.privatecast.id
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vm_low_disk_space" {
  name                = "alert-${lower(var.project_name)}-vm-low-disk"
  resource_group_name = module.resource_group.name
  location            = var.location

  scopes               = [module.avm-res-operationalinsights-workspace.resource_id]
  severity             = 2
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  criteria {
    query = <<-QUERY
      Perf
      | where TimeGenerated > ago(15m)
      | where ObjectName == "Logical Disk"
      | where CounterName == "% Free Space"
      | where _ResourceId =~ "${module.avm-res-compute-virtualmachine.resource_id}"
      | where InstanceName != "_Total"
      | summarize FreeSpacePercent = avg(CounterValue)
          by bin(TimeGenerated, 5m), _ResourceId, Computer, InstanceName
    QUERY

    time_aggregation_method = "Average"
    metric_measure_column   = "FreeSpacePercent"
    resource_id_column      = "_ResourceId"
    operator                = "LessThan"
    threshold               = 15

    dimension {
      name     = "InstanceName"
      operator = "Include"
      values   = ["*"]
    }

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 2
      number_of_evaluation_periods             = 3
    }
  }

  query_time_range_override = "PT15M"
  auto_mitigation_enabled   = true

  action {
    action_groups = [
      azurerm_monitor_action_group.privatecast.id
    ]
  }

  description = "Alerts when a PrivateCast VM disk has less than 15 percent free space."

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vm_heartbeat_missing" {
  name                = "alert-${lower(var.project_name)}-vm-heartbeat-missing"
  resource_group_name = module.resource_group.name
  location            = var.location

  scopes               = [module.avm-res-operationalinsights-workspace.resource_id]
  severity             = 1
  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"

  criteria {
    query = <<-QUERY
      Heartbeat
      | where TimeGenerated > ago(10m)
      | where Category == "Azure Monitor Agent"
      | where _ResourceId =~ "${module.avm-res-compute-virtualmachine.resource_id}"
      | summarize HeartbeatCount = count()
    QUERY

    time_aggregation_method = "Minimum"
    metric_measure_column   = "HeartbeatCount"
    operator                = "LessThan"
    threshold               = 1

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled = true

  action {
    action_groups = [
      azurerm_monitor_action_group.privatecast.id
    ]
  }

  description = "Alerts when the PrivateCast VM stops sending Azure Monitor Agent heartbeats."

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}