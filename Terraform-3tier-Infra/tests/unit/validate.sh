#!/bin/bash
set -e
terraform fmt -check -recursive
terraform validate
tflint --chdir=environments/dev
tfsec .
