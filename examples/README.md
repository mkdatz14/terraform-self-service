# Examples

This directory contains examples for implementing the self-service HCP Terraform workflow.

## Overview

These examples demonstrate Terraform configurations, Sentinel policies, and GitHub Actions workflows for automated infrastructure provisioning.

## Examples

### 1. Basic Workspace Configuration
**Directory**: [`basic-workspace/`](./basic-workspace/)

Minimal HCP Terraform boilerplate template with:
- HCP Terraform cloud backend, can be deployed via GitHub actions
- AWS provider setup
- Standard variables and tagging
- Example S3 bucket resource

### 2. Sentinel Policies
**Directory**: [`sentinel-policies/`](./sentinel-policies/)

Policy examples for governance:
- Cost control (instance type restrictions, monthly limits)
- Security (S3 encryption requirements)
- Compliance (required tags)

### 3. GitHub Actions Deployment
**Directory**: [`github-actions/`](./github-actions/)

CI/CD workflow for deploying via HCP Terraform:
- Automatic plan on pull requests
- Runs linter on Terraform
- Plan comments on PRs
- Auto-apply on merge to main

## MCP Server Integration

These examples work alongside MCP server orchestration:

1. **Pre-Terraform**: Use Terraform MCP server to discover latest provider/module versions
2. **Terraform Execution**: Deploy infrastructure via GitHub Actions
3. **Post-Terraform**: Monitor runs and handle policy checks

## See Also

- [MCP Usage Patterns](../docs/MCP_USAGE.md)
- [Terraform MCP Tools](../docs/TERRAFORM_MCP.md)
- [Architecture](../docs/ARCHITECTURE.md)
- [Quick Start](../QUICKSTART.md)
