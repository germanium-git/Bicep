param vnetName string = 'my-test-vnet'

param subnetName string = 'default'

resource symbolicname 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.10.5.0/24'
        }
      }
    ]
  }
}
