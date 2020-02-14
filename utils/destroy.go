package utils

import (
	"github.com/stretchr/testify/require"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// Source github.com/gruntwork-io/terratest/modules/terraform/destroy.go
// Adding option for working dir

// TgDestroyAll runs terragrunt destroy with the given options and return stdout.
func TgDestroyAll(t *testing.T, options *terraform.Options, workingDir string) string {
	out, err := TgDestroyAllE(t, options, workingDir)
	require.NoError(t, err)
	return out
}

// TgDestroyAllE runs terragrunt destroy with the given options and return stdout.
func TgDestroyAllE(t *testing.T, options *terraform.Options, workingDir string) (string, error) {
	if options.TerraformBinary != "terragrunt" {
		return "", terraform.TgInvalidBinary(options.TerraformBinary)
	}

	return terraform.RunTerraformCommandE(t, options, terraform.FormatArgs(options, "destroy-all", "-force", "-input=false", "-lock=false", "-terragrunt-working-dir=" + workingDir)...)
}
