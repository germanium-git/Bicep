param location string
param userIdentityName string

resource userAssignedIdentity_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userIdentityName
  location: location
}


resource storage_account_contributor 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: '${guid(resourceGroup().name, 'Storage Account Contributor')}'
  scope: resourceGroup()
  properties: {
    principalId: userAssignedIdentity_resource.properties.principalId
    roleDefinitionId: '${subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')}'
  }
}


resource storage_blob_data_contributor 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: '${guid(resourceGroup().name, 'Storage Blob Data Contributor')}'
  scope: resourceGroup()
  properties: {
    //delegatedManagedIdentityResourceId: userAssignedIdentity_resource.id
    principalId: userAssignedIdentity_resource.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '${subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')}'
  }
}

output userIdentity string = userAssignedIdentity_resource.id
