param(
    [Parameter(Mandatory=$True, Position=0)]
    [System.String]
    $resourceGroup,

    [Parameter(Mandatory=$True, Position=1)]
    [System.String]
    $accountName,

    [Parameter(Mandatory=$True, Position=2)]
    [System.String]
    $primaryRegion,

    [Parameter(Mandatory=$True, Position=3)]
    [System.String]
    $secondaryRegion
)

Write-Host "ResourceGroup:  $resourceGroup"
Write-Host "CosmosDB:       $accountName"
Write-Host "PrimaryRegion:  $primaryRegion"
Write-Host "SecondaryRegion:$secondaryRegion"


# get the existing account details.
Write-Host "---------- Azure Cosmos DB $accountName with $resourceGroup ----------"
$comosDbName = az cosmosdb show -g "$resourceGroup" -n "$accountName" --query name -o tsv

# Enable service-managed failover on an existing account
Write-Host "---------- Azure Cosmos DB $comosDbName Updating ----------"
az cosmosdb update --name $comosDbName --resource-group $resourceGroup --enable-automatic-failover true

# Add a region
Write-Host "---------- Add region to Cosmos DB $comosDbName ----------"
az cosmosdb update --name $comosDbName --resource-group $resourceGroupName --locations regionName=$primaryRegion failoverPriority=0 isZoneRedundant=True --locations regionName=$secondaryRegion failoverPriority=1 isZoneRedundant=True
Write-Host "Primary:    $resourceGroup | $primaryRegion"
Write-Host "Secondary:  $resourceGroup | $secondaryRegion"
