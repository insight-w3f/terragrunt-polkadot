package test

import (
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"log"
	"path"
	"testing"
)

func TestTerragruntAwsComplete(t *testing.T) {
	t.Parallel()

	folderPath := ".."
	baseFolder, err := files.CopyTerragruntFolderToTemp(folderPath, t.Name())
	if err != nil {
		log.Println(err)
	}

	log.Print(baseFolder)


	terraformOptions := &terraform.Options{
		TerraformDir:    path.Join(baseFolder),
		TerraformBinary: "terragrunt",
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.TgDestroyAll(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraform.TgApplyAll(t, terraformOptions)
	})
}
