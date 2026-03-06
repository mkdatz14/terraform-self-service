# Sentinel Policy Examples

Example policies for governing self-service infrastructure provisioning.

## Policies

### Security
- [require-s3-encryption.sentinel](require-s3-encryption.sentinel) - Require server-side encryption on S3 buckets

### Compliance
- [enforce-required-tags.sentinel](enforce-required-tags.sentinel) - Require Environment, Project, and Owner tags

## Usage

Apply these policies to your HCP Terraform organization via policy sets. See the [Sentinel Policies documentation](../../docs/SENTINEL_POLICIES.md) for implementation details.
