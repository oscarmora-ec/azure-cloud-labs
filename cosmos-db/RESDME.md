# Cosmos DB Notes

## Account Structure

## Key Concepts
- Account → top level resource in Azure
- Database → groups related containers
- Container → where data lives (like a table)
- Document → individual JSON record
- Partition Key → /type (Indoor/Outdoor)

## Useful Queries
```sql
-- Get all activities
SELECT * FROM activities a

-- Filter by type
SELECT * FROM activities a WHERE a.type = "Outdoor"

-- Filter by age
SELECT * FROM activities a 
WHERE a.ageMin <= 3 AND a.ageMax >= 3

-- Get specific fields only
SELECT a.name, a.type, a.city FROM activities a

-- Multiple containers with aliases
SELECT a.name, r.rating
FROM activities a
JOIN reviews r ON a.id = r.activityId
```

## CLI Command to Create Cosmos DB
```bash
az cosmosdb create \
    --name playspot-db \
    --resource-group $PLAYSPOT_RG \
    --locations regionName=eastus \
    --capabilities EnableServerless \
    --tags Project=PlaySpot Environment=Dev Owner=Oscar Version=1.0
```

## Documents Added
- 001: Shawsheen River Park (Outdoor, Andover MA)
- 002: Kidville Indoor Play (Indoor, Burlington MA)
- 003: Discovery Museum (Indoor, Acton MA)