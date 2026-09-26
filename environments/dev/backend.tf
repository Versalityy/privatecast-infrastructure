terraform {
  backend "azurerm" {
    use_cli          = true
    use_azuread_auth = true

    storage_account_name = "stprivatecasttf1234"
    container_name       = "tfstate"
    key                  = "privatecast-dev.tfstate"
  }
}