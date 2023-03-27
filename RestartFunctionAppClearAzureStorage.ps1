Connect-AzAccount
Set-AzContext -Subscription "subscription_id"

$ResourceGroup = "ResourceGroupName"
$WebApp = 'WebAppName'
$WebAppSlot = 'WebAppName' #Keep blank if not valid

$StorageAccountName = "StorageAccountName"
$FunctionApp = "FunctionAppName"
$FunctionAppSlot = ''

# Restart WebApp
if($WebAppSlot -eq '')
{
  $result = Restart-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebApp
}
else 
{
  $result = Restart-AzWebAppSlot -ResourceGroupName $ResourceGroup -Name $WebApp -Slot $WebAppSlot
}

# Clear Storage Account Containers, Queues and Tables
$StorageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccountName
$ctx = ""
$ctx = $storageAccount.Context

$containers = Get-AzStorageContainer -Context $ctx 
foreach ($container in $containers)
{
  Write-Host $container.Name
  Remove-AzStorageContainer  -Context $ctx -Name $container.Name -Force
}
 
$queues = Get-AzStorageQueue -Context $ctx | Select-Object Name
foreach ($queue in $queues)
{
  Write-Host $queue
  Remove-AzStorageQueue  -Context $ctx -Name $queue.Name -Force
}

$tables = Get-AzStorageTable -Context $ctx | Select-Object Name
foreach ($table in $tables)
{
  Write-Host $table
  Remove-AzStorageTable  -Context $ctx -Name $table.Name -Force
}

# Restart FunctionApp
if($FunctionAppSlot -eq '')
{
  $result = Restart-AzFunctionApp -ResourceGroupName $ResourceGroup -Name $FunctionApp -Force
}
else 
{
  $Result = Restart-AzWebAppSlot -ResourceGroupName $ResourceGroup -Name $FunctionApp -Slot $FunctionAppSlot -Force
}