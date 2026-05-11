# Azure Functions Notes

## Overview
Azure Functions is a serverless compute service that runs 
code on demand without managing infrastructure.

## Key Concepts
Trigger      → what causes the function to run
HTTP, timer, queue, Cosmos DB change
Binding      → how function connects to other services
Input binding reads data automatically
Output binding writes data automatically
Runtime      → language the function runs in
Node.js, Python, C#, Java
Consumption  → serverless pricing model
First 1 million executions free per month

## PlaySpot Function App
- **Name:** playspot-api
- **Region:** Central US
- **Runtime:** Node.js 22
- **Plan:** Consumption (Serverless)
- **GitHub:** github.com/oscarmora-ec/playspot-functions

## GetActivities Function
- **Trigger:** HTTP GET
- **Auth Level:** Anonymous
- **URL:** https://playspot-api.azurewebsites.net/api/getactivities
- **Purpose:** Reads all activities from Cosmos DB and returns as JSON

## Local Development Setup
```bash
# Install Node.js from nodejs.org first

# Install Azure Functions Core Tools
npm install -g azure-functions-core-tools@4 --unsafe-perm true

# Verify installation
func --version

# Create new project
func init myproject --javascript

# Start function locally
func start

# Deploy to Azure
func azure functionapp publish FUNCTION_APP_NAME
```

## local.settings.json
Used for local development only. Never pushed to GitHub.
Contains connection strings and environment variables.
```json
{
    "IsEncrypted": false,
    "Values": {
        "AzureWebJobsStorage": "storage connection string",
        "FUNCTIONS_WORKER_RUNTIME": "node",
        "COSMOS_CONNECTION": "cosmos db connection string"
    }
}
```

## Deploying App Settings to Azure
When deploying to Azure, local.settings.json is NOT used.
Must set app settings manually via CLI:
```bash
az functionapp config appsettings set \
    --name FUNCTION_APP_NAME \
    --resource-group RESOURCE_GROUP \
    --settings "KEY=VALUE"
```

## GetActivities Code
```javascript
const { app } = require('@azure/functions');
const { CosmosClient } = require('@azure/cosmos');

const client = new CosmosClient(process.env.COSMOS_CONNECTION);
const database = client.database('playspot-database');
const container = database.container('activities');

app.http('GetActivities', {
    methods: ['GET'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        const { resources: activities } = await container.items
            .query({ query: 'SELECT * FROM activities' })
            .fetchAll();

        return {
            status: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify(activities)
        };
    }
});
```

## REST API Types
GET     → Read data (what we built)
POST    → Create new data
PUT     → Update existing data
DELETE  → Remove data


## Lessons Learned
- Portal created functions had runtime issues with Node.js 22
- Always develop locally first then deploy
- local.settings.json must be in .gitignore
- App settings in Azure replace local.settings.json
- Function URLs are always lowercase in Azure
- Use --verbose flag when debugging deployments