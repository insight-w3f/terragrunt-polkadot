package test

import (
	"github.com/gruntwork-io/terratest/modules/files"
	//"github.com/gruntwork-io/terratest/modules/random"
	//"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/insight-w3f/terragrunt-polkadot/utils"
	//"./insight-w3f/terragrunt-polkadot/utils"
	//"../../../../utils"
	//"io/ioutil"
	"log"
	"path"
	"testing"
)

func TestTerragruntGcpComplete(t *testing.T) {
	t.Parallel()

	folderPath := ".."
	baseFolder, err := files.CopyTerragruntFolderToTemp(folderPath, t.Name())
	if err != nil {
		t.Fatal(err)
	}

	log.Print(t, baseFolder)

	//fixturesDir := path.Join(folderPath, "test/fixtures")
	//privateKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test")
	//publicKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test.pub")

	//keyPair := ssh.GenerateRSAKeyPair(t, 4096)
	//privKeyPath := path.Join(exampleFolder, uniqueID)
	//uniqueID := random.UniqueId()
	//err = ioutil.WriteFile(privKeyPath, []byte(keyPair.PrivateKey), 0600)
	//if err != nil {
	//	t.Fatal(err)
	//}

	utils.GenerateKeys(t, baseFolder)

	testFolder := "polkadot/gcp"

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
