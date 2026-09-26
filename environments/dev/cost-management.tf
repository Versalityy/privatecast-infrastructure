resource "azurerm_consumption_budget_subscription" "privatecast" {
  name            = "budget-${lower(var.project_name)}-dev"
  subscription_id = var.subscription_id

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = var.budget_start_date
  }
  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"

    contact_emails = [
      var.alert_email_address
    ]
  }
  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Forecasted"

    contact_emails = [
      var.alert_email_address
    ]
    contact_groups = [
      azurerm_monitor_action_group.privatecast.id
    ]
  }
  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Forecasted"

    contact_emails = [
      var.alert_email_address
    ]
    contact_groups = [
      azurerm_monitor_action_group.privatecast.id
    ]
  }
}
