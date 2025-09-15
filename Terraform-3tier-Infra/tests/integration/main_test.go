package test

import (
	"crypto/tls"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDevDeploy(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../../environments/dev",
	}

	// Always destroy at the end
	defer terraform.Destroy(t, opts)

	terraform.InitAndApply(t, opts)

	// Get the output
	fqDns := terraform.OutputRequired(t, opts, "Domain_Website")
	url := "http://" + fqDns

	// Retry until healthy
	maxRetries := 10
	sleep := 5 * time.Second
	success := false

	for i := 0; i < maxRetries; i++ {
		status, _ := http_helper.HttpGet(t, url, &tls.Config{InsecureSkipVerify: true})
		if status == 200 {
			t.Logf("✅ Website is healthy at %s (status %d)", url, status)
			success = true
			break
		}
		t.Logf("Attempt %d/%d failed (status %d). Retrying in %s...",
			i+1, maxRetries, status, sleep)
		time.Sleep(sleep)
	}

	if !success {
		t.Fatalf("❌ Website did not become healthy after %d retries", maxRetries)
	}
}
