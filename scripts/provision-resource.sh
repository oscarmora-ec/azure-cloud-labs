#!bin/bash
# ============================================
# PlaySpot Resource Provisioning Script
# ============================================
# Purpose: Creates Azure resources for a new
#          environment automatically
# Author: Oscar Mora
# Date: May 2026
# ============================================

# ============================================
# VARIABLES
# ============================================
# Define all variables at the top of the script
# This makes it easy to change values later
# without hunting through the entire script

# Resource group name
RESOURCE_GROUP="cli-practice-rg"

# Location for all resources
# Always keep resources in the same region
LOCATION="eastus2"

# Location for all resources
# Always keep resources in the same region
STORAGE_ACCOUNT="clipracticestorage002"

#Container name in the storage account
CONTAINER_NAME="practice-container"

#tag values for resource organization
#using the same tas as out PlaySpot standar
TAGS="Project=Learning Environment=Dev Owner=Oscar"

# ============================================
# SCRIPT START
# ============================================
echo "============================================"
echo "PlaySpot Resource Provisioning Script"
echo "============================================"

# ============================================
# STEP 1 - Create Resource Group
# ============================================
echo ""
echo "Step 1: Creating resource group $RESOURCE_GROUP..."

az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION \
    --tags $TAGS

# Check if previous command succeded
# $? holds the exit code of the last command
# 0 means success, anything else is an error
if [ $? -eq 0 ]; then
echo "Resource group created successfully"
else
    echo "Failed to create resource group. Stopping script."
    exit 1
fi

# ============================================
# STEP 2 - Create Storage Account
# ============================================
echo ""
echo "Step 2: Creating storage account $STORAGE_ACCOUNT..."

az storage account create \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_LRS \
    --kind StorageV2 \
    --access-tier Cool \
    --tags $TAGS

if [ $? -eq 0 ]; then
    echo "Storage account created successfully"
else
    echo "Failed to create storage account. Stopping script."
    exit 1
fi

# ============================================
# STEP 3 - Create Storage Container
# ============================================
echo ""
echo "Step 3: Creating container $CONTAINER_NAME..."

az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT \
    --auth-mode login

if [ $? -eq 0 ]; then
    echo "Container created successfully"
else
    echo "Failed to create container. Stopping script."
    exit 1
fi

# ============================================
# STEP 4 - Verify Everything Was Created
# ============================================
echo ""
echo "Step 4: Verifying resources..."

echo ""
echo "Resource Group:"
az group show \
    --name $RESOURCE_GROUP \
    --query "{Name:name, Location:location, State:properties.provisioningState}" \
    --output table

echo ""
echo "Storage Account:"
az storage account show \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --query "{Name:name, Location:primaryLocation, Tier:accessTier}" \
    --output table

echo ""
echo "Storage Container:"
az storage container list \
    --account-name $STORAGE_ACCOUNT \
    --auth-mode login \
    --query "[].{Name:name}" \
    --output table

# ============================================
# SCRIPT COMPLETE
# ============================================
echo ""
echo "============================================"
echo "Provisioning Complete"
echo "Resources created in $RESOURCE_GROUP"
echo "============================================"