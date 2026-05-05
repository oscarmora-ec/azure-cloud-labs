#!/bin/bash
# ============================================
# PlaySpot Service Principal Login Script
# ============================================
# Purpose: Securely login to Azure using SP
#          credentials stored in Key Vault
# Author: Oscar Mora
# Date: May 2026
# ============================================

# Step 1 - Login as owner account first
# This is required to access Key Vault
echo "Step 1: Logging in as owner account..."
az login --tenant eacf9e47-b12c-4e9b-a510-0e3c06b6aaaf

# Step 2 - Retrieve SP credentials from Key Vault
# Credentials are stored securely, never hardcoded
echo "Step 2: Retrieving credentials from Key Vault..."
SP_APPID=$(az keyvault secret show \
    --vault-name playspot-kv \
    --name "playspot-sp-appid" \
    --query value \
    --output tsv)

SP_SECRET=$(az keyvault secret show \
    --vault-name playspot-kv \
    --name "playspot-sp-secret" \
    --query value \
    --output tsv)

TENANT=$(az keyvault secret show \
    --vault-name playspot-kv \
    --name "playspot-tenant-id" \
    --query value \
    --output tsv)

# Step 3 - Verify credentials were retrieved
# Only print non-sensitive values
echo "Step 3: Verifying credentials retrieved..."
echo "App ID: $SP_APPID"
echo "Tenant: $TENANT"
echo "Secret: Retrieved successfully (not displayed for security)"

# Step 4 - Login as Service Principal
echo "Step 4: Logging in as Service Principal..."
az login \
    --service-principal \
    --username $SP_APPID \
    --password $SP_SECRET \
    --tenant $TENANT

# Step 5 - Verify SP login
echo "Step 5: Verifying SP login..."
az account show --query user.name --output tsv

echo "============================================"
echo "Ready to work as PlaySpot Service Principal"
echo "============================================"