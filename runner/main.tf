# create terraform provider block for azuread azurm random and time
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 2.90.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.22"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "random" {}

provider "time" {}
