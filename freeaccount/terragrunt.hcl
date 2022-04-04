# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  # These cannot be variables.  
  # Note: Azure doesn't need something like a DynamoDB for locking.  Storage does that.
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatefjbo4"
    container_name       = "tfstate"
    key                  = "ssd-grunt/${path_relative_to_include()}/terraform.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}
EOF
}
