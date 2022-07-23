package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/packer"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

const EKSTerraformWorkingDir = "./eks"
const VPCTerraformWorkingDir = "./vpc"

const AmazonEksAl2PackerTemplate = "../amazon-eks-al2.pkr.hcl"
const Al2Arm64PackerVars = "../al2_arm64.pkrvars.hcl"
const Al2x86_64PackerVars = "../al2_x86_64.pkrvars.hcl"

const DefaultTimeBetweenPackerRetries = 15 * time.Second
const DefaultMaxPackerRetries = 3

// This is a complicated, end-to-end integration test. It builds the AMI from examples/packer-docker-example,
// deploys it using the Terraform code on examples/terraform-packer-example, and checks that the web server in the AMI
// response to requests. The test is broken into "stages" so you can skip stages by setting environment variables (e.g.,
// skip stage "build_ami" by setting the environment variable "SKIP_build_ami=true"), which speeds up iteration when
// running this test over and over again locally.
func TestTerraformPackerExample(t *testing.T) {
	t.Parallel()

	// awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	awsRegion := "us-west-2"

	// At the end of the test, undeploy the web app using Terraform
	defer test_structure.RunTestStage(t, "cleanup_vpc", func() {
		undeployUsingTerraform(t, VPCTerraformWorkingDir)
	})

	// At the end of the test, delete the AMI
	defer test_structure.RunTestStage(t, "cleanup_ami", func() {
		awsRegion := test_structure.LoadString(t, workingDir, "awsRegion")
		deleteAMI(t, awsRegion, workingDir)
	})

	// // At the end of the test, fetch the most recent syslog entries from each Instance. This can be useful for
	// // debugging issues without having to manually SSH to the server.
	// defer test_structure.RunTestStage(t, "logs", func() {
	// 	awsRegion := test_structure.LoadString(t, workingDir, "awsRegion")
	// 	fetchSyslogForInstance(t, awsRegion, workingDir)
	// })

	// Deploy VPC w/ Terraform
	test_structure.RunTestStage(t, "deploy_vpc", func() {
		deployVpc(t, awsRegion, VPCTerraformWorkingDir)
	})

	// Build the AMI w/ Packer
	test_structure.RunTestStage(t, "build_al2_x86_64_ami", func() {
		uniqueDataName := "al2-x86_64"
		buildAMI(t, awsRegion, AmazonEksAl2PackerTemplate, Al2x86_64PackerVars, uniqueDataName)
	})

	// // Validate that the web app deployed and is responding to HTTP requests
	// test_structure.RunTestStage(t, "validate", func() {
	// 	validateInstanceRunningWebServer(t, workingDir)
	// })
}

// Stage 1 - Provison VPC w/ Terraform
func deployVpc(t *testing.T, awsRegion string, workingDir string) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: VPCTerraformWorkingDir,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region": awsRegion,
			// "name":   name,
		},
	})

	test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

// Stage 2 - Build the AMI w/ Packer
func buildAmi(t *testing.T, awsRegion string, template string, varFile string, uniqueDataName: string) {
	packerOptions := &packer.Options{
		Template: template,

		VarFiles: []string{
			varFile,
		},

		// RetryableErrors:    DefaultRetryablePackerErrors,
		TimeBetweenRetries: DefaultTimeBetweenPackerRetries,
		MaxRetries:         DefaultMaxPackerRetries,
	}

	test_structure.SaveTestData(t, test_structure.FormatTestDataPath(uniqueDataName, "PackerOptions.json"), packerOptions)

	amiID := packer.BuildArtifact(t, packerOptions)

	// Save the AMI ID so future test stages can use them
	test_structure.SaveTestData(t, test_structure.FormatTestDataPath(uniqueDataName, "PackerAmiId.json"), amiID)
}

// // Delete the AMI
// func deleteAMI(t *testing.T, awsRegion string, workingDir string) {
// 	// Load the AMI ID and Packer Options saved by the earlier build_ami stage
// 	amiID := test_structure.LoadAmiId(t, workingDir)

// 	aws.DeleteAmi(t, awsRegion, amiID)
// }

// // Deploy the terraform-packer-example using Terraform
// func deployUsingTerraform(t *testing.T, awsRegion string, workingDir string) {
// 	// A unique ID we can use to namespace resources so we don't clash with anything already in the AWS account or
// 	// tests running in parallel
// 	uniqueID := random.UniqueId()

// 	// Give this EC2 Instance and other resources in the Terraform code a name with a unique ID so it doesn't clash
// 	// with anything else in the AWS account.
// 	instanceName := fmt.Sprintf("terratest-http-example-%s", uniqueID)

// 	// Specify the text the EC2 Instance will return when we make HTTP requests to it.
// 	instanceText := fmt.Sprintf("Hello, %s!", uniqueID)

// 	// Some AWS regions are missing certain instance types, so pick an available type based on the region we picked
// 	instanceType := aws.GetRecommendedInstanceType(t, awsRegion, []string{"t2.micro", "t3.micro"})

// 	// Load the AMI ID saved by the earlier build_ami stage
// 	amiID := test_structure.LoadAmiId(t, workingDir)

// 	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
// 	// terraform testing.
// 	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
// 		// The path to where our Terraform code is located
// 		TerraformDir: workingDir,

// 		// Variables to pass to our Terraform code using -var options
// 		Vars: map[string]interface{}{
// 			"aws_region":    awsRegion,
// 			"instance_name": instanceName,
// 			"instance_text": instanceText,
// 			"instance_type": instanceType,
// 			"ami_id":        amiID,
// 		},
// 	})

// 	// Save the Terraform Options struct, instance name, and instance text so future test stages can use it
// 	test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)

// 	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
// 	terraform.InitAndApply(t, terraformOptions)
// }

// // Undeploy the terraform-packer-example using Terraform
func undeployUsingTerraform(t *testing.T, workingDir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	terraform.Destroy(t, terraformOptions)
}

// // Fetch the most recent syslogs for the instance. This is a handy way to see what happened on the Instance as part of
// // your test log output, without having to re-run the test and manually SSH to the Instance.
// func fetchSyslogForInstance(t *testing.T, awsRegion string, workingDir string) {
// 	// Load the Terraform Options saved by the earlier deploy_terraform stage
// 	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

// 	instanceID := terraform.OutputRequired(t, terraformOptions, "instance_id")
// 	logs := aws.GetSyslogForInstance(t, instanceID, awsRegion)

// 	logger.Logf(t, "Most recent syslog for Instance %s:\n\n%s\n", instanceID, logs)
// }

// // Validate the web server has been deployed and is working
// func validateInstanceRunningWebServer(t *testing.T, workingDir string) {
// 	// Load the Terraform Options saved by the earlier deploy_terraform stage
// 	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

// 	// Run `terraform output` to get the value of an output variable
// 	instanceURL := terraform.Output(t, terraformOptions, "instance_url")

// 	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
// 	tlsConfig := tls.Config{}

// 	// Figure out what text the instance should return for each request
// 	instanceText, _ := terraformOptions.Vars["instance_text"].(string)

// 	// It can take a minute or so for the Instance to boot up, so retry a few times
// 	maxRetries := 30
// 	timeBetweenRetries := 5 * time.Second

// 	// Verify that we get back a 200 OK with the expected instanceText
// 	http_helper.HttpGetWithRetry(t, instanceURL, &tlsConfig, 200, instanceText, maxRetries, timeBetweenRetries)
// }
