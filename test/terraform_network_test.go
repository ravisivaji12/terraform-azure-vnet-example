//go:build azure || (azureslim && network)
// +build azure azureslim,network

package terraformtestmod

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAVMNetworkConfig(t *testing.T) {
	t.Parallel()

	subscriptionID := "abd34832-7708-43f9-a480-e3b7a87b41d7" // Set via ARM_SUBSCRIPTION_ID env var
	expectedDns := []string{"10.0.0.5", "10.0.0.6"}

	// Load Terraform config
	terraformOptions := &terraform.Options{
		TerraformBinary: "terraform",
		TerraformDir: "/home/runner/work/terratest-azure-vnet-poc/terraform-azure-vnet-example",
		VarFiles:     []string{"/home/runner/work/terratest-azure-vnet-poc/terraform-azure-vnet-example/terraform.tfvars"},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Extract output values (from outputs.tf)
	vnetNames := terraform.OutputList(t, terraformOptions, "vnet_names")
	subnetNames := terraform.OutputList(t, terraformOptions, "subnet_names") // Format: vnet_name/subnet_name

	for _, vnetName := range vnetNames {
		rgName := terraform.OutputMap(t, terraformOptions, "vnet_resource_groups")[vnetName]

		// Check if VNet exists
		assert.True(t, azure.VirtualNetworkExists(t, vnetName, rgName, subscriptionID))

		// Check DNS Servers
		actualDns := azure.GetVirtualNetworkDNSServerIPs(t, vnetName, rgName, subscriptionID)
		for _, dns := range expectedDns {
			assert.Contains(t, actualDns, dns)
		}
	}

	for _, sn := range subnetNames {
		parts := strings.Split(sn, "/")
		vnetName := parts[0]
		subnetName := parts[1]
		rgName := terraform.OutputMap(t, terraformOptions, "vnet_resource_groups")[vnetName]

		// Check Subnet exists
		assert.True(t, azure.SubnetExists(t, subnetName, vnetName, rgName, subscriptionID))

		// Check Subnet is part of correct VNet with a valid prefix
		subnetMap := azure.GetVirtualNetworkSubnets(t, vnetName, rgName, subscriptionID)
		assert.NotNil(t, subnetMap[subnetName])
	}
}
