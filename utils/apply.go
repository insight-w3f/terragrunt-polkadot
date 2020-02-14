package utils

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
	"testing"
)

// Source github.com/gruntwork-io/terratest/modules/terraform/apply.go
// Adding option for working dir

// TgApplyAll runs terragrunt apply with the given options and return stdout/stderr. Note that this method does NOT call destroy and
// assumes the caller is responsible for cleaning up any resources created by running apply.
func TgApplyAll(t *testing.T, options *terraform.Options, workingDir string) string {
	out, err := TgApplyAllE(t, options, workingDir)
	require.NoError(t, err)
	return out
}

// TgApplyAllE runs terragrunt apply-all with the given options and return stdout/stderr. Note that this method does NOT call destroy and
// assumes the caller is responsible for cleaning up any resources created by running apply.
func TgApplyAllE(t *testing.T, options *terraform.Options, workingDir string) (string, error) {
	if options.TerraformBinary != "terragrunt" {
		return "", terraform.TgInvalidBinary(options.TerraformBinary)
	}

	return terraform.RunTerraformCommandE(t, options, terraform.FormatArgs(options, "apply-all", "-input=false", "-lock=false", "-auto-approve", "-terragrunt-working-dir=" + workingDir)...)
}
