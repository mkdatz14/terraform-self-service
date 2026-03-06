# Terraform MCP Server Capabilities

The Terraform MCP server provides AI agents with capabilities to automate infrastructure provisioning workflows.

## What You Can Do

### Generate Terraform Code
- Discover latest provider and module versions from public/private registries
- Query provider capabilities (available resources, data sources, functions)
- Get module documentation and required inputs
- Search for Sentinel/OPA policies

### Manage HCP Terraform Workspaces
- Search, create, update, and delete workspaces
- Link workspaces to VCS repositories
- Configure workspace settings and tags

### Execute and Monitor Runs
- Create runs (plans) and monitor their status
- Review resource changes before applying
- Apply, discard, or cancel runs
- View plan and apply logs for troubleshooting

### Manage Variables
- Create and update workspace-specific variables (Terraform or environment)
- Create variable sets to share credentials across multiple workspaces
- Attach/detach variable sets to workspaces or projects

## Critical Requirements

⚠️ **Always require explicit user confirmation before applying any run** - Never set `auto_apply=true`

When working with the Terraform MCP:
- Always fetch latest provider/module versions before generating code
- Search private registry first, then fallback to public registry
- Monitor run status and review plan details before requesting user approval
- Use variable sets for credentials that need to be shared across workspaces

## See Also

- [MCP Usage Guide](./MCP_USAGE.md)
- [Architecture](./ARCHITECTURE.md)
- [Setup Guide](./SETUP.md)
