
@description('Storage Account to enable guest level metrics')
@minLength(3)
@maxLength(24)
param storageName string


@description('KeyVault to store the shared key')
param keyVaultName string

@description('Name of the connection string stored in KV')
var keySecretName = 'key-${storageName}'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}


resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name : keyVaultName
}

// Store the connection string in KV
resource storageAccountConnectionString 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: keySecretName
  parent: keyVault
  properties: {
    value: storageAccount.listKeys().keys[0].value
  }
}
