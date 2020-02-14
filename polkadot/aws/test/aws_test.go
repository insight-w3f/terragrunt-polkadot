package test

import (
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/insight-infrastructure/terragrunt-polkadot/utils"
	"log"
	"os"
	"path"
	"testing"
)

func TestTerragruntAwsComplete(t *testing.T) {
	t.Parallel()

	testFolder, err := files.CopyTerragruntFolderToTemp("../../..", t.Name())
	log.Print(testFolder)

	cwd, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}

	fixturesDir := path.Join(cwd, "fixtures")
	privateKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test")
	publicKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test.pub")
	utils.GenerateKeys(privateKeyPath, publicKeyPath)

	terraformOptions := &terraform.Options{
		TerraformDir:    path.Join(testFolder, "polkadot/aws"),
		TerraformBinary: "terragrunt",
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		utils.TgDestroyAll(t, terraformOptions, path.Join(testFolder, "polkadot/aws"))
	})

	test_structure.RunTestStage(t, "setup", func() {
		utils.TgApplyAll(t, terraformOptions, path.Join(testFolder, "polkadot/aws"))
	})
}
