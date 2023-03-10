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
    $secondaryRegion,

    [Parameter(Mandatory=$True, Position=4)]
    [System.String]
    $dataBaseName,

    [Parameter(Mandatory=$True, Position=5)]
    [System.String]
    $containerName,

    [Parameter(Mandatory=$True, Position=6)]
    [System.Int64]
    $throughPut
)

Write-Host "ResourceGroup:  $resourceGroup"
Write-Host "CosmosDB:       $accountName"
Write-Host "PrimaryRegion:  $primaryRegion"
Write-Host "SecondaryRegion:$secondaryRegion"

# Trigger a manual failover to promote primaryRegion 
Write-Host "---------- Azure Cosmos DB - Failover [from '$secondaryRegion' to '$primaryRegion' region] ----------"
az cosmosdb failover-priority-change --failover-policies "$secondaryRegion=1" "$primaryRegion=0" --name $accountName --resource-group $resourceGroup

#Throughput update
Write-Host "---------- Azure Cosmos DB Sql throughput Updating ----------"
az cosmosdb sql container throughput update --name "$containerName" --max-throughput $throughPut --database-name "$dataBaseName" --account-name "$accountName" --resource-group "$resourceGroup"
