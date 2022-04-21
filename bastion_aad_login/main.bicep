param bastionName string = 'bastion01'
param vmLinuxName string = 'linux01'
param vmWinName string = 'windows01'
param location string = 'westeurope'
param adminUsername string = 'azureuser'

@secure()
param adminPassword string = newGuid()

param sshPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKRP0OEAWmAxOTtUZ9beQmKm8t0sgghVAFj1QaseDbMFSprtznHXcU/EF7YWR4wgLI25xzj8aItXxbkNav0mSoHnsyBAmDi42XUCQ5j3snGmF8f8XXu0j49d8z5cBgmiRCheoIC31EtYGzu5bkiuhOOj0k5hAOVzMVgKRdcMasRRsnAQ+VRHtR1dAYRKYQQzaKUtbdfi42xgj4QlPWM0g1t8gOA/Z52hVdX564Zh5GatEQ5QFNTuA7OI4DH1B5E5zZJLNSwE+2Kyf2VZdwc/piIX3X5s1PnJ672JZOoVKwDEMgNYWXycosZBKt4hvbyC5sSiZYQbcBJ5REv9yJRNLwZ7r/Isr5kBYebZBsfOxa36XgKKvjvNGfL5JXNYcCA6nYoaqN+W4UMNjOQg37fDaUVNUxkNFJoUUaaOihYhrWr+Ak79TB7J3ej7huAyvYCZ+bjQOTLgcBinWBsHFTzrzyBtyKTxZRhwEMCpFXljwwtRWN9M7I21XcIvlcsUwNFEzFwmyYNiTg7PKFIwu+KttQXCeVf+WnAEovJe2lGpgsJTrngyeR8M1Pfe92NXe7o2CZ9hroxmULuXahWHro99/InZkobQOIBKEJ7jnppzomXapjpKtEDudQfhMLd8PXS9nnt8xv0Ldpoz9je1l37hRr6T2Ei5RLCM5cRtT2HWX/SQ== Ansible Tower'

param vnetPrefix string = '10.13.0.0/16'
param bastionSubnet string = '10.13.1.0/24'

param subnetName string = 'subnet-10'
param subnetPrefix string = '10.13.10.0/24'


var subnetRefbastion = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_resource.name, 'AzureBastionSubnet')
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_resource.name, subnetName)


resource networkSecurityGroups_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'nsg-${resourceGroup().name}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 400
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

@description('Public IP address for the bastion')
resource publicIPAddresses_bastion_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${bastionName}-pip'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}



resource virtualNetworks_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'vnet-${resourceGroup().name}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnet
        }
      }
      {
        name: subnetName
        properties: {
        addressPrefix: subnetPrefix
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}



resource virtualMachines_linux01_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmLinuxName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vmLinuxName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_linux0_resource.id
        }
      ]
    }
  }
}



resource networkInterfaces_linux0_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${vmLinuxName}-nic01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetRef
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
    networkSecurityGroup: {
      id: networkSecurityGroups_resource.id
    }
  }
}

resource virtualMachines_linux01_AADLoginForLinux 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  parent: virtualMachines_linux01_resource
  name: 'AADSSHLoginForLinux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADSSHLoginForLinux'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}


resource bastionHosts_resource 'Microsoft.Network/bastionHosts@2021-05-01' = {
  name: bastionName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    enableTunneling: true
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_bastion_resource.id
          }
          subnet: {
            id: subnetRefbastion
          }
        }
      }
    ]
  }
}

resource networkInterfaces_windows01_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${vmWinName}-nic01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetRef
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


resource virtualMachines_windows01_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmWinName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vmWinName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      //requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_windows01_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}


resource virtualMachines_windows01_AADLoginForWindows 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  parent: virtualMachines_windows01_resource
  name: 'AADLoginForWindows'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADLoginForWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}
