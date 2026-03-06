# AI Agent Guidelines for Terraform Code Generation

This document provides steering guidelines for AI agents generating and managing Terraform infrastructure code using the Terraform MCP server. It provides best practices that help to guide the agent into generating quality Terraform, specifically in following your own standards- whether that be at enterprise or in personal projects.

## Purpose

This guide helps AI agents:
- Generate correct and high-quality Terraform code
- Follow infrastructure-as-code best practices
- Use the Terraform MCP server tools effectively
- Ensure safe infrastructure operations
- Maintain code quality and compliance

## Core Principles

### 1. Always Query Before Generating
**Never** generate Terraform code without first querying the registries:
- Get latest provider versions for all resources
- Check provider capabilities for available resources
- Search for relevant modules in the private registry
- Review module requirements and inputs
- Validate against available Sentinel policies

### 2. Safety First
**Never** apply infrastructure changes without explicit user approval:
- Always present plan output for user review
- Highlight destructive changes (deletions, replacements)
- Wait for confirmation form the user before applying
- Document what will change and why it will change

### 3. Code Quality
Generate production-ready code:
- Pin all provider versions explicitly
- Use consistent formatting (terraform fmt)
- Include meaningful variable descriptions
- Add comments explaining non-obvious decisions
- Follow HCL style guidelines
- Remain compliant with Sentinel policies

## Terraform MCP Server Capabilities

The Terraform MCP server provides two categories of tools:

### Registry Discovery (Always Available)
Query Terraform registries for providers, modules, and policies before generating code.

### HCP Terraform/Enterprise Management (When Connected)
Create and manage workspaces, execute runs, and configure variables when connected to HCP Terraform.

## Code Generation Workflow

1. **Discovery**: Query provider versions, capabilities, modules, and Sentinel policies
2. **Generation**: Create properly structured Terraform code with version constraints
3. **Validation**: Ensure code quality, policy compliance, and proper documentation
4. **Execution**: Create workspace, configure variables, run plan, get approval, apply

## Critical Safety Rules

### ⚠️ Never Auto-Apply
**ALWAYS** require explicit user confirmation before applying infrastructure changes:
- Set `auto_apply=false` when creating runs
- Present complete plan output to user
- Highlight destructive actions (delete, replace)
- Wait for explicit "yes/approve/apply" confirmation
- If unsure, err on the side of caution

### 🔒 Protect Sensitive Data
**NEVER** expose secrets in code or outputs:
- Mark sensitive variables as `sensitive = true`
- Never hardcode credentials in Terraform files
- Use variable sets for shared secrets
- Redact sensitive values in responses to users
- Store secrets in proper secret management systems

### 🛡️ Validate Before Generating
**ALWAYS** validate your approach before generating code:
- Confirm the resource type exists in provider capabilities
- Check that module versions are compatible
- Verify policy requirements can be met
- Validate variable types match expected inputs
- Ensure dependencies are properly ordered

### 🔍 Review All Changes
**ALWAYS** carefully review plans before applying:
- Check resource counts (additions, changes, deletions)
- Look for unexpected destructive actions
- Verify resource attributes match requirements
- Review plan logs for warnings or errors
- Confirm no unintended resources are affected

## Communication Best Practices

**Progress Updates**: Keep users informed with clear status messages
**Plan Presentation**: Show resource counts, highlight destructive changes, include cost estimates
**Error Explanation**: Provide clear error messages with actionable solutions

## Code Generation Best Practices

### Provider Version Management
Always pin provider versions explicitly using pessimistic constraints (~> allows patch updates):
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }
}
```

### Code Structure
- Use established modules when appropriate
- Add variable validation for input constraints
- Mark sensitive outputs as `sensitive = true`
- Use consistent resource naming: `${project}-${environment}-${resource}`
- Apply standard tags: ManagedBy, Environment, Project
- Organize files: main.tf, variables.tf, outputs.tf, versions.tf

### Documentation
Add comments explaining non-obvious decisions and policy compliance

## Code Quality Validation

Before presenting generated code, verify:
- Provider versions are pinned
- Variables have types and descriptions
- Sensitive outputs marked appropriately
- Resources have meaningful names
- Tags applied consistently
- No hardcoded secrets
- Code follows terraform fmt formatting
- Comments explain decisions
- Policy requirements satisfied

## Sentinel Policy Integration

Sentinel is HashiCorp's policy-as-code framework for governance and compliance enforcement in HCP Terraform.

### Enforcement Levels
- **Hard-Mandatory**: Blocks deployment; must fix code to comply
- **Soft-Mandatory**: Can be overridden with justification
- **Advisory**: Warning only; doesn't block deployment

### Policy-Aware Workflow
1. Query policies with `search_policies()` and `get_policy_details()`
2. Review requirements (encryption, tagging, regions, etc.)
3. Generate compliant code with validation
4. Document policy compliance in comments

### Example
```hcl
# Complies with: require-s3-encryption (hard-mandatory)
resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

## Security Best Practices

- Never hardcode credentials; use environment variables or variable sets
- Mark sensitive variables and outputs as `sensitive = true`
- Follow least privilege for IAM policies
- Use remote state with encryption
- Never commit state files or secrets to version control

## Summary

When generating Terraform code as an AI agent:

1. **Always Query First**: Get provider versions, capabilities, module details, and Sentinel policies before generating code
2. **Policy Compliance**: Search for and understand applicable Sentinel policies; generate code that satisfies policy requirements to avoid deployment failures
3. **Safety First**: Never auto-apply; always require explicit user approval for infrastructure changes
4. **Generate Quality Code**: Pin versions, add descriptions, include comments, follow HCL style
5. **Security Conscious**: Never hardcode secrets, mark sensitive data, follow least privilege
6. **User Focused**: Communicate clearly, present plans understandably, explain errors with solutions
7. **Validate Everything**: Check provider capabilities, test generated code, verify policy compliance
8. **Performance Aware**: Cache registry queries, use efficient Terraform patterns, batch operations

Following these guidelines ensures you generate production-ready, secure, compliant, and maintainable Terraform infrastructure code.
