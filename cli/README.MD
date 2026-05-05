# Azure CLI Notes

## Login and Account Management
```bash
# Login to Azure with specific tenant
az login --tenant TENANT_ID

# Show current logged in account
az account show

# List all subscriptions
az account list --output table

# Set default tenant
az config set defaults.tenant=TENANT_ID
```

## Resource Groups
```bash
# List all resource groups
az group list --output table

# Show specific resource group
az group show --name playspot-rg

# Create a resource group
az group create --name mygroup-rg --location eastus2

# Delete a resource group
az group delete --name mygroup-rg
```

## Resources
```bash
# List all resources in a resource group
az resource list --resource-group playspot-rg --output table

# List resources by tag
az resource list --tag Project=PlaySpot --output table

# Filter specific columns
az resource list --query "[].{Name:name, Type:type}" --output table
```

## Storage
```bash
# List storage accounts
az storage account list --output table

# List containers
az storage container list --account-name playspotimages001 --output table

# List blobs in container
az storage blob list --account-name playspotimages001 --container-name playground-images --output table

# Always use auth-mode login for security
az storage container list --account-name playspotimages001 --auth-mode login --output table
```

## Security and RBAC
```bash
# List all role assignments
az role assignment list --all --output table

# List roles for specific user
az role assignment list --assignee user@email.com --output table

# Assign a role
az role assignment create \
--assignee user@email.com \
--role "Contributor" \
--scope /subscriptions/SUB_ID/resourceGroups/playspot-rg

# Delete a role assignment by ID
az role assignment delete --ids ASSIGNMENT_ID

# List all users
az ad user list --output table

# Create a user
az ad user create \
--display-name "Name" \
--user-principal-name user@domain.onmicrosoft.com \
--password "Password123!" \
--force-change-password-next-sign-in true

# Delete a user
az ad user delete --id user@domain.onmicrosoft.com
```

## Service Principals
```bash
# Create a service principal with role
az ad sp create-for-rbac \
--name "playspot-sp" \
--role "Contributor" \
--scopes /subscriptions/SUB_ID/resourceGroups/playspot-rg

# Login as service principal
az login \
--service-principal \
--username APP_ID \
--password SECRET \
--tenant TENANT_ID

# Reset SP credentials
az ad app credential reset --id APP_ID --append

# Update SP display name
az ad app update --id APP_ID --display-name "New Name"

# List all service principals
az ad sp list --output table
```

## Tips
```bash
# Add --output table to any command for clean output
# Add --query to filter specific fields
# Always use --auth-mode login for storage commands
# Use --help on any command for documentation
az group --help
```

## Resource Lifecycle
```bash
# Create a resource group
az group create \
--name cli-practice-rg \
--location eastus2 \
--tags Project=Learning Environment=Dev Owner=Oscar

# Create a storage account
az storage account create \
--name clipracticestorage001 \
--resource-group cli-practice-rg \
--location eastus2 \
--sku Standard_LRS \
--kind StorageV2 \
--access-tier Cool

# Verify storage account
az storage account list \
--resource-group cli-practice-rg \
--output table

# Delete storage account
az storage account delete \
--name clipracticestorage001 \
--resource-group cli-practice-rg \
--yes

# Delete resource group and everything in it
az group delete --name cli-practice-rg --yes

# Verify cleanup
az group list --output table
```