variable "cc_location" {
  description = "The location of the resources"
  type        = string
}

variable "cc_core_resource_group_name" {
  description = "The name of the core resource group"
  type        = string
}

variable "cc_storage_resource_group_name" {
  description = "The name of the storage resource group"
  type        = string
}

variable "kv_name" {
  description = "Key Vault Name"
  type        = string
}

variable "cc_vnet" {
  description = "Configuration for VNets and Subnets"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = map(object({
      name                              = string
      address_prefixes                  = list(string)
      service_endpoints                 = list(string)
      nsg_name                          = string
      private_endpoint_network_policies = string
      delegation = list(object({
        name = string
        service_delegation = object({
          name    = string
          actions = list(string)
        })
      }))
    }))
  }))
}

variable "sku_name" {
  description = "Key Vault SKU"
  type        = string
}

variable "soft_delete_retention_days" {
  description = "Retention period for soft delete"
  type        = number
}

variable "purge_protection_enabled" {
  description = "If purge protection is enabled"
  type        = bool
}

variable "public_network_access_enabled" {
  description = "If public network access is enabled"
  type        = bool
}

variable "enabled_for_deployment" {
  description = "If enabled for deployment"
  type        = bool
}

variable "enabled_for_disk_encryption" {
  description = "If enabled for disk encryption"
  type        = bool
}

variable "enabled_for_template_deployment" {
  description = "If enabled for template deployment"
  type        = bool
}

variable "enable_rbac_authorization" {
  description = "If RBAC authorization is enabled"
  type        = bool
}
