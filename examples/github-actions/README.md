# GitHub Actions for HCP Terraform

Example GitHub Actions workflow for linting Terraform code before it reaches HCP Terraform.

## Usage

1. Copy [terraform-deploy.yml](terraform-deploy.yml) to `.github/workflows/` in your repository

2. No configuration needed - the workflow runs automatically on push and PR

## Workflow Behavior

### On Pull Request and Push
- Runs `terraform fmt -check` to verify formatting
- Runs `tflint` for additional linting checks
- Comments results on PRs
- Fails the workflow if issues are found

## What Gets Checked

- **Format Check**: Ensures consistent Terraform formatting
- **TFLint**: Detects potential errors, deprecated syntax, naming conventions, and best practices

## Local Testing

Before pushing, run these commands locally:

```bash
# Format your code
terraform fmt -recursive

# Install tflint
brew install tflint  # macOS
# or: curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Run tflint
tflint --init
tflint
```

## Customization

### Add Custom TFLint Rules

Create a `.tflint.hcl` file in your repository:

```hcl
plugin "aws" {
  enabled = true
  version = "0.30.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}
```

### Disable Specific Checks

Modify the workflow to skip format or lint checks as needed.
