# Authenticate with managed identity
Connect-AzAccount -Identity

# Generate SAS token for the storage account
$context = (Get-AzStorageAccount -ResourceGroupName 'rg-nemedpet-storage-privendpoint' -AccountName 'sto20220215').context
$sasToken = (New-AzStorageAccountSASToken -Context $context -Service Blob,File,Table,Queue -ResourceType Service,Container,Object -Permission racwdlup)


# Specify the storage context
$StorageAccountName = 'sto20220215'
$ContainerName = 'backup'
$StorageContext = New-AzStorageContext $StorageAccountName -SasToken $sasToken
$storageContainer = Get-AzStorageContainer -Name $ContainerName -Context $StorageContext

# Upload the file to teh container
$storageContainer | Set-AzStorageBlobContent -File 'test3.txt' -Blob 'test3.txt'