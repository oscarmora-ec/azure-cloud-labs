#!/bin/bash
# ============================================
# PlaySpot Resource Cleanup Script
# ============================================
# Purpose: Removes practice resources to
#          avoid unnecessary costs
# Author: Oscar Mora
# Date: May 2026
# ============================================

# Resource group to delete
RESOURCE_GROUP="cli-practice-rg"

echo "============================================"
echo "Cleanup Script - Removing Practice Resources"
echo "============================================"

# Warn before deleting
echo ""
echo "WARNING: This will delete $RESOURCE_GROUP"
echo "and ALL resources inside it."
echo ""

# Ask for confirmation
# read -p shows a prompt and waits for input
# The input is stored in CONFIRM variable
read -p "Are you sure? Type 'yes' to continue: " CONFIRM

# Check if user typed yes
if [ "$CONFIRM" = "yes" ]; then
    echo ""
    echo "Deleting resource group $RESOURCE_GROUP..."
    
    az group delete \
        --name $RESOURCE_GROUP \
        --yes
    
    if [ $? -eq 0 ]; then
        echo "Cleanup complete. All resources deleted."
    else
        echo "Cleanup failed. Please check Azure portal."
    fi
else
    # If user did not type yes cancel the operation
    echo "Cleanup cancelled. No resources deleted."
fi

echo "============================================"