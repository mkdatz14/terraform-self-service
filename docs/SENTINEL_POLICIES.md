# Sentinel Policy Enforcement

Integrating Sentinel policies with the self-service HCP Terraform workflow to provide governance and guardrails for automated infrastructure provisioning.

## Policy Set Configuration

Apply Sentinel policies globally or to specific workspaces created by the workflow:

```hcl
resource "tfe_policy_set" "self_service_guardrails" {
  name          = "self-service-guardrails"
  description   = "Guardrails for self-service infrastructure"
  organization  = var.tfe_organization
  global        = true  # Apply to all workspaces

  policies_path = "policies/"
  vcs_repo {
    identifier         = "your-org/terraform-policies"
    branch            = "main"
    oauth_token_id     = var.github_oauth_token_id
  }
}

# Or scope to specific workspace tags
resource "tfe_policy_set" "environment_specific" {
  name          = "production-strict"
  description   = "Stricter policies for production workspaces"
  organization  = var.tfe_organization
  
  policies_path = "policies/"
  vcs_repo {
    identifier         = "your-org/terraform-policies"
    branch            = "main"
    oauth_token_id     = var.github_oauth_token_id
  }
  
  # Apply only to production workspaces
  workspace_ids = [
    for ws in tfe_workspace.environments : 
    ws.id if contains(ws.tag_names, "production")
  ]
}
```

## Workflow Integration

### Policy Enforcement in Self-Service Deployments

All Sentinel policy checks are evaluated during the HCP Terraform plan phase. Policy failures are automatically flagged and halt the deployment process.

**Hard-Mandatory Policies**: Block deployment entirely. Require configuration changes to comply.

**Soft-Mandatory Policies**: Block deployment by default but can be overridden. All overrides require manual review and approval from an experienced engineer with justification documented in the run.

**Advisory Policies**: Generate warnings but do not block deployment. Used for best practice recommendations.

### Manual Review Process

When policy checks fail:

1. Run is paused at policy check stage
2. Engineer reviews the policy failure details in HCP Terraform UI
3. Engineer assesses whether:
   - Configuration should be updated to comply with policy
   - Override is justified (soft-mandatory only)
4. For overrides, engineer documents justification and approves via HCP Terraform
5. Status is updated in SailPoint request with outcome

### Policy Evaluation Flow

```
Terraform Plan → Policy Check → [Pass] → Ready for Apply
                              ↓ [Fail - Hard]
                              ↳ Block & Require Config Update
                              ↓ [Fail - Soft] 
                              ↳ Request Manual Review → Override or Update
```

## Recommended Policy Areas for Self-Service

### 1. Cost Controls
- Monthly cost delta limits (environment-specific)
- Instance type restrictions
- Volume size limits

### 2. Security Requirements
- Mandatory encryption at rest
- No public access without justification
- Required security group rules
- Mandatory tags for ownership and billing

### 3. Compliance
- Allowed regions
- Required backup configurations
- Logging and monitoring requirements

### 4. Standards
- Approved module sources only
- Naming conventions
- Required resource tags

## Example Policies

### Cost Control: Limit Instance Types

```sentinel
import "tfplan/v2" as tfplan

# Allowed instance types for self-service
allowed_instance_types = ["t3.micro", "t3.small", "t3.medium"]

main = rule {
  all tfplan.resource_changes as _, rc {
    rc.type is not "aws_instance" or
    rc.change.after.instance_type in allowed_instance_types
  }
}
```

### Security: Require S3 Bucket Encryption

```sentinel
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as _, rc {
    rc.type is not "aws_s3_bucket" or
    rc.change.after.server_side_encryption_configuration is not null
  }
}
```

### Compliance: Enforce Required Tags

```sentinel
import "tfplan/v2" as tfplan

required_tags = ["Environment", "Project", "Owner"]

main = rule {
  all tfplan.resource_changes as _, rc {
    all required_tags as tag {
      rc.change.after.tags[tag] else null is not null
    }
  }
}
```

### Cost Control: Limit Monthly Spend Increase

```sentinel
import "tfrun" as tfrun

# Maximum allowed monthly cost increase (in dollars)
max_monthly_delta = 100.0

main = rule {
  tfrun.cost_estimate.delta_monthly_cost < max_monthly_delta
}
```

1. **Start Permissive**: Begin with advisory policies, graduate to mandatory as confidence builds
2. **Clear Feedback**: Ensure policy messages provide actionable guidance
3. **Document Overrides**: Track all soft-mandatory overrides with justification
4. **Regular Reviews**: Analyze policy violation patterns to improve defaults or documentation
5. **Environment Graduation**: Stricter policies for production than development
6. **Cost Awareness**: Prevent accidental expensive deployments in self-service context
