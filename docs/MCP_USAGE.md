# MCP Server Usage Patterns

This guide explains how to orchestrate GitHub and Terraform MCP servers to implement the self-service HCP Terraform workflow.

## Overview

The self-service workflow coordinates two primary MCP servers to automate infrastructure provisioning:

- **GitHub MCP Server**: Repository and code management
- **Terraform MCP Server**: Provider/module discovery and workspace orchestration

Additionally you can configure the Confluence MCP Server, to be able to connect your your Jira documentation and read best practices.

**Workflow Initiation**: In the production workflow, requests come through SailPoint which triggers the automated workflow.

## MCP Server Orchestration

### GitHub MCP Server

The GitHub MCP server handles repository lifecycle management:

**Key Capabilities:**
- Create repositories with proper structure
- Configure branch protection rules
- Set up webhooks for HCP Terraform integration
- Manage repository access and permissions
- Add collaborators and teams
- Configure Sentinel policies

### Terraform MCP Server

The Terraform MCP server provides two main capabilities:

**Registry Discovery** (Always Available):
- Query latest provider versions
- Search public and private module registries
- Get provider capabilities and documentation
- Find Sentinel/OPA policies

**HCP Terraform Management** (When Connected):
- Create and configure workspaces
- Link workspaces to VCS repositories
- Execute and monitor plans/applies
- Manage variables and variable sets
- Access private modules

## Best Practices

### Repository Structure
Use consistent structure for all generated repositories:
```
repository-name/
├── main.tf           # Primary resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Provider versions
├── terraform.tfvars  # Default values (non-sensitive)
├── README.md         # Documentation
└── .github/
    └── workflows/    # CI/CD if needed
```

### Workspace Naming Convention
Use clear, consistent naming:
```
{project}-{environment}-{purpose}

Examples:
- customer-portal-prod-compute
- data-pipeline-dev-storage
- api-gateway-staging-networking
```

### Error Handling
Implement robust error handling:
```
1. Plan Failure
   → Get plan logs via get_plan_logs(plan_id)
   → Parse error messages
   → Suggest fixes to user
   → Update SailPoint request with error details

2. Apply Failure
   → Get apply logs via get_apply_logs(apply_id)
   → Check workspace state
   → Determine if rollback needed
   → Document incident

3. Repository Conflicts
   → Check for existing repositories before creating
   → Handle naming collisions gracefully
   → Suggest alternative names
```

### Security Considerations

**Secrets Management:**
- Never commit sensitive values to repositories
- Always use HCP Terraform variables with `sensitive=true`
- Use variable sets for shared credentials in HCP Terraform
- Rotate credentials regularly

**Access Control:**
- Grant minimum required permissions
- Use team-based access in GitHub
- Leverage workspace teams in HCP Terraform
- Audit access logs regularly

**Code Review:**
- Require pull request reviews for production changes
- Use branch protection rules
- Enforce Sentinel policies for compliance
- Document approval requirements

## Monitoring and Observability

### Track Key Metrics
- Repository creation success rate
- Workspace creation success rate
- Plan success vs failure rate
- Apply success vs failure rate
- Time from request to deployment
- Policy override frequency

### Logging Strategy
Log all MCP operations:
```
{
  "timestamp": "2026-03-03T10:15:30Z",
  "request_id": "SAIL-12345",
  "operation": "create_workspace",
  "workspace_name": "project-prod-compute",
  "status": "success",
  "duration_ms": 1250
}
```

## Use the Template

As part of the self-service workflow, the platform team provides a boilerplate HCP Terraform GitHub repository template with the minimum configuration needed to deploy infrastructure.

See the [example-config.tf](../examples/basic-workspace/example-config.tf) template to get started.

The template includes:
- Terraform backend configuration for HCP Terraform
- Standard variable definitions
- Output structure
- Basic README documentation

## See Also

- **[AI Agent Guidelines](../AGENTS.md)** - Comprehensive guide for AI agents generating Terraform code
- **[Terraform MCP Server Capabilities](./TERRAFORM_MCP.md)** - Detailed tool reference
- **[Sentinel Policy Enforcement](./SENTINEL_POLICIES.md)** - Governance and compliance policies
- **[Example Configurations](../examples/)** - Sample Terraform configurations and workflows
