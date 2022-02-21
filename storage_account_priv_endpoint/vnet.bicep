param vnetName string
param location string
param subnetsConfig array
param vnetIpPrefix string
param nsgId string


resource vnet_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetIpPrefix
      ]
    }
    subnets: [for subnet in subnetsConfig: {
        name: subnet.name
        properties: {
          serviceEndpoints:[
            {
              service: 'Microsoft.Storage'
            }
          ]
          addressPrefix: subnet.range
          privateEndpointNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

output vnetId string = vnet_resource.id
output subnets array = vnet_resource.properties.subnets
