package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func U20ArmTest(t *testing.T) {
 	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/u20arm",
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
