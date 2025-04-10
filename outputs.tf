output "vnet_names" {
  value = [for k, vnet in var.cc_vnet : vnet.name]
}

output "subnet_names" {
  value = flatten([
    for vnet_key, vnet in var.cc_vnet :
    [for subnet_key, subnet in vnet.subnets :
      "${vnet.name}/${subnet.name}"
    ]
  ])
}


output "vnet_resource_groups" {
  value = {
    for k, v in var.cc_vnet :
    v.name => v.resource_group_name
  }
}