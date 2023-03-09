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

# Create an account with 2 regions
Write-Host "---------- Azure Cosmos DB $accountName with $resourceGroup ----------"
az cosmosdb create --name $accountName --resource-group $resourceGroupName --locations regionName=$primaryRegion failoverPriority=0 isZoneRedundant=False --locations regionName=$secondaryRegion failoverPriority=1 isZoneRedundant=False --default-consistency-level Session

# Add a region
Write-Host "---------- Add region to Cosmos DB $accountName ----------"
az cosmosdb update --name $accountName --resource-group $resourceGroupName --locations regionName=$primaryRegion failoverPriority=0 isZoneRedundant=True --locations regionName=$secondaryRegion failoverPriority=1 isZoneRedundant=True
Write-Host "Primary:    $resourceGroup | $primaryRegion"
Write-Host "Secondary:  $resourceGroup | $secondaryRegion"
