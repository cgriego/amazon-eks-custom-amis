package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformScpExample(t *testing.T) {
	t.Parallel()

	awsRegion := "us-west-2"

	vpcOptions := createVpcTerraformOptions()
	defer terraform.Destroy(t, vpcOptions)
	terraform.InitAndApply(t, vpcOptions)
	validateVpc()
}
