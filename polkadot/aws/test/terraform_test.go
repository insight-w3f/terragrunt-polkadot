package test

import (
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/insight-infrastructure/terragrunt-polkadot/scripts"
	"log"
	"os"
	"path"
	"testing"
)

func TestTerragruntAwsComplete(t *testing.T) {
	t.Parallel()

	baseDir := scripts.GetBaseDirectory()

	baseFolder := test_structure.CopyTerraformFolderToTemp(t, baseDir, "polkadot/aws")
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	cwd, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}

	fixturesDir := path.Join(cwd, "fixtures")
	privateKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test")
	publicKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test.pub")
	scripts.GenerateKeys(privateKeyPath, publicKeyPath)

	terraformOptions := &terraform.Options{
		TerraformDir:    baseFolder,
		TerraformBinary: "terragrunt",
		Vars: map[string]interface{}{
			"aws_region":         awsRegion,
			"public_key_path":    publicKeyPath,
			//"private_key_path":   privateKeyPath,
		},
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, terraformOptions)
	})
}
