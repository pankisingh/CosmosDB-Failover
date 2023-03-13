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
    $databaseName,

    [Parameter(Mandatory=$True, Position=5)]
    [System.Boolean]
    $testMode
)

$updateThroughput=10000

Write-Host "ResourceGroup:  $resourceGroup"
Write-Host "CosmosDB:       $accountName"
Write-Host "PrimaryRegion:  $primaryRegion"
Write-Host "SecondaryRegion:$secondaryRegion"


# Trigger a manual failover to promote secondaryRegion 
Write-Host "----- Azure Cosmos DB - Failover [from '$primaryRegion' to '$secondaryRegion' region] ------"
az cosmosdb failover-priority-change --failover-policies "$secondaryRegion=0" "$primaryRegion=1" --name $accountName --resource-group $resourceGroup

# Retrieve the current provisioned database throughput
Write-Host "Retrieve the current provisioned database throughput"
az cosmosdb sql database throughput show --resource-group $resourceGroup --account-name $accountName --name $databaseName --query resource.throughput -o tsv

# Retrieve the minimum allowable database throughput
$minimumThroughput=$(az cosmosdb sql database throughput show --resource-group $resourceGroup --account-name $accountName --name $databaseName --query resource.minimumThroughput -o tsv)

# Make sure the updated throughput is not less than the minimum allowed throughput
Write-Host "Make sure the updated throughput is not less than the minimum allowed throughput"
if ($updateThroughput -lt $minimumThroughput){
    $updateThroughput = $minimumThroughput
}

# Update database throughput
Write-Host "Updating $databaseName throughput to $updateThroughput"
az cosmosdb sql database throughput update --account-name $accountName --resource-group $resourceGroup --name $databaseName --max-throughput $updateThroughput
