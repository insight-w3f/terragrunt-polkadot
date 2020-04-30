package test

import (
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/insight-w3f/terragrunt-polkadot/utils"
	"log"
	"path"
	"testing"
)

func TestTerragruntPacketComplete(t *testing.T) {
	t.Parallel()

	folderPath := "../../../"
	baseFolder, err := files.CopyTerragruntFolderToTemp(folderPath, t.Name())
	if err != nil {
		log.Println(err)
	}

	log.Print(baseFolder)

	fixturesDir := path.Join(folderPath, "test/fixtures")
	privateKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test")
	publicKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test.pub")
	utils.GenerateKeys(privateKeyPath, publicKeyPath)

	testFolder := "polkadot/packet"

	terraformOptions := &terraform.Options{
		TerraformDir:    path.Join(baseFolder, testFolder),
		TerraformBinary: "terragrunt",
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		utils.TgDestroyAll(t, terraformOptions, path.Join(baseFolder, testFolder))
	})

	test_structure.RunTestStage(t, "setup", func() {
		utils.TgApplyAll(t, terraformOptions, path.Join(baseFolder, testFolder))
	})

}
