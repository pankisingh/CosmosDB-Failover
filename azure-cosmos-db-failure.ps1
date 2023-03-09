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
Write-Host "Secondary:      $secondaryRegion"
Write-Host "PrimaryRegion:  $dataBaseName"
Write-Host "Secondary:      $containerName"

# Enable service-managed failover on an existing account
Write-Host "---------- Azure Cosmos DB $accountName Updating ----------"
az cosmosdb update --name $accountName --resource-group $resourceGroup --enable-automatic-failover true

# Trigger a manual failover to promote secondaryRegion 
Write-Host "---------- Azure Cosmos DB - Failover [from '$primaryRegion' to '$secondaryRegion' region] ----------"
az cosmosdb failover-priority-change --failover-policies "$secondaryRegion=0" "$primaryRegion=1" --name $accountName --resource-group $resourceGroup

#Throughput update
Write-Host "---------- Azure Cosmos DB Sql throughput Updating ----------"
az cosmosdb sql container throughput update --name "$containerName" --max-throughput $throughPut --database-name "$dataBaseName" --account-name "$accountName" --resource-group "$resourceGroup"