// Example: Agnostic-ish storage module for AWS/Azure with enforced tags
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws     = { source = "hashicorp/aws", version = "~> 5.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

variable "cloud" {
  description = "Target cloud: aws or azure"
  type        = string
}

variable "name" { type = string }
variable "location" { type = string }
variable "tags" {
  type = map(string)
  validation {
    condition     = contains(keys(var.tags), "dono") && contains(keys(var.tags), "projeto") && contains(keys(var.tags), "custo_centro") && contains(keys(var.tags), "ambiente") && contains(keys(var.tags), "data_criacao")
    error_message = "Mandatory tags missing (dono, projeto, custo_centro, ambiente, data_criacao)."
  }
}

provider "aws" {
  region = var.location
}

provider "azurerm" {
  features {}
}

# AWS path
resource "aws_s3_bucket" "b" {
  count  = var.cloud == "aws" ? 1 : 0
  bucket = "${var.name}-bucket"
  tags   = var.tags
}

# Azure path
resource "azurerm_resource_group" "rg" {
  count    = var.cloud == "azure" ? 1 : 0
  name     = "${var.name}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "sa" {
  count                    = var.cloud == "azure" ? 1 : 0
  name                     = replace(lower("${var.name}sa"), "/[^a-z0-9]/", "")
  resource_group_name      = azurerm_resource_group.rg[0].name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}
