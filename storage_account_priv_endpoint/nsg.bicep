param location string
param name string

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: name
  location: location
  properties: {
    securityRules: [
      {
        name: 'rdp-internal-allow'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'icmp-internal-allow'
        properties: {
          priority: 2000
          protocol: 'Icmp'
          access: 'Allow'
          direction: 'Inbound'
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

output nsgId string = nsg.id
