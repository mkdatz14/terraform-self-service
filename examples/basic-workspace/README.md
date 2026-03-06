# HCP Terraform Boilerplate Template

This is the minimal boilerplate configuration for deploying infrastructure via HCP Terraform in the self-service workflow.

## What's Included

- HCP Terraform cloud backend configuration
- AWS provider setup
- Standard variables (region, environment, project)
- Example S3 bucket resource (replace with your infrastructure)
- Basic output

## Usage

### 1. Configure Your Organization and Workspace

Edit the `cloud` block in `example-config.tf`:

```hcl
cloud {
  organization = "your-org-name"
  
  workspaces {
    name = "your-workspace-name"
  }
}
```

### 2. Set Required Variables

Create a `terraform.tfvars` file:

```hcl
environment  = "dev"
project_name = "my-project"
aws_region   = "us-east-1"  # optional, defaults to us-east-1
```

### 3. Deploy via GitHub Actions

Push your configuration to GitHub:

```bash
git add .
git commit -m "Initial infrastructure configuration"
git push
```

GitHub Actions will automatically:
- Initialize Terraform with HCP Terraform backend
- Generate a plan for review
- Wait for approval before applying changes

View the run and approve it in your HCP Terraform workspace.

## Customization

Replace the example S3 bucket resource with your actual infrastructure needs. The template provides a starting structure with standard variables and tagging.

## See Also

- [MCP Usage Patterns](../../docs/MCP_USAGE.md)
- [Terraform MCP Tools](../../docs/TERRAFORM_MCP.md)
- [Architecture](../../docs/ARCHITECTURE.md)
