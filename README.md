# Self-Service HCP Terraform Workflow

A comprehensive, automated workflow for enabling users to provision and manage infrastructure through HCP Terraform with integrated GitHub repository management and SailPoint request tracking. A generalized example based on a previous RTS engagement.

## Overview

This self-service workflow enables users to:
- Request infrastructure provisioning through a structured process
- Automatically generate GitHub repositories with Terraform code
- Deploy infrastructure via HCP Terraform workspaces

## Architecture Components

### 1. **GitHub MCP Server**
Manages repository lifecycle:
- Create new repositories for Terraform projects
- Set up branch protection rules
- Configure repository settings and webhooks
- Manage access permissions

### 2. **Terraform MCP Server**
Handles infrastructure code generation and deployment:
- Search and validate latest provider/module versions
- Connected to HCP Terraform organization for access to private modules
- Generate compliant Terraform code via Sentinel
- Create and manage HCP Terraform workspaces
- Execute plans and applies through HCP Terraform API
- Manage workspace variables and variable sets

### 3. **Request Management**
Workflow is initiated through SailPoint:
- Users request infrastructure access/provisioning through SailPoint
- Requests trigger the automated workflow
- Audit trail maintained throughout process
- Results documented and linked back to request

## Workflow Process

```
SailPoint Request → Validate Access → Create GitHub Repo → Generate Terraform Code → 
Create HCP Workspace → Link Repo to Workspace → Configure Variables → 
Deploy Infrastructure → Complete Request
```

## Key Features

- **Automated Repository Creation**: New GitHub repositories are automatically created with proper structure
- **Code Generation**: Terraform code is generated using latest provider versions and best practices
- **Workspace Management**: HCP Terraform workspaces are created and configured automatically
- **Variable Management**: Sensitive variables and configuration managed through HCP Terraform
- **Audit Trail**: Complete tracking from SailPoint request through deployment
- **Version Control Integration**: VCS-driven workflows with GitHub integration

## Prerequisites

1. **GitHub Access**
   - GitHub organization with admin access
   - Personal access token with `repo`, `workflow`, and `admin:org` scopes

2. **HCP Terraform**
   - HCP Terraform organization
   - User token with workspace and variable management permissions
   - VCS connection to GitHub configured

3. **SailPoint Integration**
   - SailPoint instance configured for infrastructure requests
   - Webhook or API integration to trigger workflow

4. **MCP Servers**
   - GitHub MCP server (for repository management)
   - Terraform MCP server with enterprise tools enabled (for workspace orchestration)

## Use Cases

### 1. New Infrastructure
User requests a new infrastructure setup (e.g., AWS VPC with EKS cluster) through SailPoint:
- Request validated and approved through SailPoint workflow
- GitHub repository created with Terraform structure
- HCP Terraform workspace created and linked to repository
- Terraform code generated using validated modules
- Infrastructure deployed through HCP Terraform

### 2. Multi-Environment Deployment
User needs dev, staging, and production environments:
- Single SailPoint request tracks all environments
- GitHub repository with workspace-specific configurations
- Multiple HCP workspaces created (dev, staging, prod)
- Variable sets configured for environment-specific values
- Graduated deployments through environments

## Security Considerations

- **Credential Management**: All sensitive credentials stored in HashiCorp Vault
- **Access Control**: Repository and workspace permissions managed through teams
- **Audit Logging**: All operations tracked from SailPoint through deployment
- **Policy Enforcement**: Sentinel/OPA policies applied in HCP Terraform
- **Branch Protection**: Main branch protected, requires PR reviews from experienced team

## Benefits

- **Reduced Time to Deploy**: Minutes instead of days for infrastructure provisioning
- **Consistency**: Standardized approach ensures compliance and best practices
- **Transparency**: Full audit trail from SailPoint request to deployment
- **Scalability**: Supports multiple teams and projects simultaneously
- **Self-Service**: Empowers users while maintaining governance

## Implementation Approach

This workflow is implemented through orchestration of MCP servers:

1. **Higher-Level Terraform Configuration**: Use Terraform's HCP provider to provision workspaces, variable sets, and manage infrastructure lifecycle
2. **MCP Server Integration**: Call MCP server tools to coordinate GitHub and HCP Terraform operations
3. **Event-Driven**: Trigger workflow stages based on SailPoint requests, GitHub events, or API calls

## Troubleshooting

### Common Issues

**MCP Server Not Connecting**
- Verify environment variables are set correctly
- Check token permissions and expiration

**Workspace Creation Fails**
- Confirm VCS connection is configured in HCP Terraform
- Verify organization name matches `TFE_ORGANIZATION`
- Check user token has workspace creation permissions

**Policy Violations**
- Query policies first: `search_policies()` → `get_policy_details()`
- Review policy requirements and adjust Terraform code
- For soft-mandatory policies, override with justification

**Variable Not Found**
- Check variable is created in correct workspace
- For shared variables, use variable sets
- Verify sensitive variables are marked correctly

## FAQ

**Q: Can I use this without SailPoint?**  
A: Yes, trigger the workflow via API, webhooks, or manual execution.

**Q: Does this work with Terraform Enterprise?**  
A: Yes, set `TFE_HOSTNAME` to your TFE instance URL.

**Q: How do I handle multiple AWS accounts?**  
A: Use variable sets for account-specific credentials and workspace prefixes.

**Q: Can I customize the generated Terraform code?**  
A: Yes, modify the code generation logic or use custom templates.

**Q: What happens if a run fails?**  
A: Monitor via `get_run_details()`, review logs, fix issues, and retry with `create_run()`.

**Q: How do I prevent auto-applies?**  
A: Always set `auto_apply: false` in `create_run()` and require explicit approval.

## Support and Resources

- [Sentinel Policy Enforcement](./docs/SENTINEL_POLICIES.md)
- [Terraform MCP Server Tools Reference](./docs/TERRAFORM_MCP.md)
- [MCP Tool Usage Patterns](./docs/MCP_USAGE.md)
- [HCP Terraform Provider Docs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers)
- [Terraform MCP Server](https://github.com/modelcontextprotocol/servers)
