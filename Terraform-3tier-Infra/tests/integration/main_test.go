package test

import (
	"crypto/tls"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDevDeploy(t *testing.T) {
	// Define Terraform options for the dev environment
	opts := &terraform.Options{
		TerraformDir: "../../environments/dev",
	}

	// Safety net: always try to clean up, even on failure
	defer terraform.Destroy(t, opts)

	// Deploy infra
	terraform.InitAndApply(t, opts)

	// Get the website domain from Terraform output
	fqDns := terraform.Output(t, opts, "Domain_Website")
	url := "http://" + fqDns

	// Retry loop: stop immediately once healthy
	maxRetries := 10
	sleep := 5 * time.Second
	success := false

	for i := 0; i < maxRetries; i++ {
		status, _ := http_helper.HttpGet(t, url, &tls.Config{InsecureSkipVerify: true})
		if status == 200 {
			t.Logf("✅ Website is healthy at %s (status %d)", url, status)
			success = true
			break
		} else {
			t.Logf("Attempt %d/%d failed (status %d). Retrying in %s...",
				i+1, maxRetries, status, sleep)
			time.Sleep(sleep)
		}
	}

	if !success {
		t.Fatalf("❌ Website did not become healthy after %d retries", maxRetries)
	}

	// Explicit cleanup right after success (ensures destroy even if defer is skipped later)
	terraform.Destroy(t, opts)
}
