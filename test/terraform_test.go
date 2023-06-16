package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http_helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	t.Parallel()
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "public_ip")

	url := fmt.Sprint("http://%S:8080", public_ip1, public_ip2)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, world!", 40, 5*time.Second)
}
