resource storagewitness 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'sdssq00stowitness2021'
  location: resourceGroup().location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: false
    isNfsV3Enabled: false
  }
}

output storageBlobEndpoint string = storagewitness.properties.primaryEndpoints.blob
