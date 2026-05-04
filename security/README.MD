# Security Notes

## Key Vault
Azure Key Vault is used to store all sensitive information
securely instead of hardcoding in scripts or code.

### Key Vault Created
- Name: playspot-kv
- Resource Group: playspot-rg
- Location: East US 2

### Secrets Stored
- playspot-sp-secret → Service Principal password
- playspot-sp-appid → Service Principal App ID
- playspot-tenant-id → Azure Tenant ID

### Useful Commands
```bash
# Create a Key Vault
az keyvault create \
--name playspot-kv \
--resource-group playspot-rg \
--location eastus2

# Store a secret
az keyvault secret set \
--vault-name playspot-kv \
--name "secret-name" \
--value "secret-value"

# List all secrets
az keyvault secret list \
--vault-name playspot-kv \
--output table

# Retrieve a secret value
az keyvault secret show \
--vault-name playspot-kv \
--name "secret-name" \
--query value \
--output tsv

# Delete a secret
az keyvault secret delete \
--vault-name playspot-kv \
--name "secret-name"
```

## Service Principal
- Name: PlaySpot Service Principal
- Role: Contributor on playspot-rg only
- Secret expiry: 1 year
- Credentials stored in Key Vault

## RBAC Model
```
Owner account (aldair4024)
→ Full subscription access
→ MFA enabled
→ Used for billing and admin only

Service Principal (playspot-sp)
→ Contributor on playspot-rg only
→ Used for CLI automation
→ Secret stored in Key Vault

Key Vault Administrator
→ Assigned to owner account
→ Scoped to playspot-kv only
```