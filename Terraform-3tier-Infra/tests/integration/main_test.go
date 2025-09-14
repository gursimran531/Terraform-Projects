package test

import (
	"crypto/tls"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDevDeploy(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../../environments/dev",
		VarFiles:     []string{"../../environments/dev/dev.auto.tfvars"},
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	albDns := terraform.Output(t, opts, "alb_website")

	// Updated to match current Terratest HttpGetWithRetry signature
	http_helper.HttpGetWithRetry(
		t,
		"http://"+albDns,          // URL
		&tls.Config{InsecureSkipVerify: true}, // TLS config (nil is OK for HTTP)
		200,                        // Expected status code
		"",                         // Expected body (empty = ignore)
		10,                         // Number of retries
		5*time.Second,              // Sleep duration between retries
	)
}
