param location string
param subnetId string
param storageName string
param containerName string
param storageFwipRules array
param privDnsZone string
param vnetId string



resource storageAccounts_resource 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: subnetId
          action: 'Allow'
        }
      ]
      ipRules: storageFwipRules
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
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


resource container_resource 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageName}/default/${containerName}'
  properties:{
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_resource
  ]
}

/*
resource storage_nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${storageName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}
*/

resource privateEndpoints_resource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: '${storageName}-endpoint'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${storageName}-privlink-{$vnetName}'
        properties: {
          privateLinkServiceId: storageAccounts_resource.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: subnetId
    }
    customDnsConfigs: [
      {
        fqdn: '${storageName}.${privDnsZone}'
      }
    ]
  }
}


resource privateEndpoint_dns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  name: '${privateEndpoints_resource.name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-database-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_resource.id
        }
      }
    ]
  }
}


resource privateDnsZones_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privDnsZone
  location: 'global'
  properties: {
  }
}


resource privateDnsZones_vnet_links 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_resource
  name: 'vnet-storage-privendpoint'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}


resource privateDnsZones_storage_a_record 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_resource
  name: storageName
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: privateEndpoints_resource.properties.customDnsConfigs[0].ipAddresses[0]
      }
    ]
  }
}


/*
resource privateDnsZones_storage_cname_record 'Microsoft.Network/privateDnsZones/CNAME@2018-09-01' = {
  parent: privateDnsZones_resource
  name: storageName
  properties: {
    ttl: 3600
    cnameRecord: {
      cname: privateEndpoints_resource.properties.customDnsConfigs[0].fqdn
    }
  }
}
*/
