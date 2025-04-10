module "MF_MDI_CC-RG" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.1"
  name     = var.cc_core_resource_group_name
  location = var.cc_location
  # tags     = local.tag_list_1
}

module "MF_MDI_CC_STORAGE-RG" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.1"
  name     = var.cc_storage_resource_group_name
  location = var.cc_location
  # tags     = local.tag_list_1
}
resource "azurerm_virtual_network" "vnet" {
  for_each = var.cc_vnet

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = ["10.0.0.5", "10.0.0.6"]

  dynamic "subnet" {
    for_each = each.value.subnets

    content {
      name              = subnet.value.name
      address_prefixes  = subnet.value.address_prefixes
      service_endpoints = subnet.value.service_endpoints
      // Remove the invalid attribute and handle NSG association separately
      private_endpoint_network_policies = subnet.value.private_endpoint_network_policies
      //delegation                        = subnet.delegation
    }
  }
}
