param location string
param vmName string
param subnetId string
param userIdentity string
param username string
param password string = newGuid()

@description('Create public IP address')
resource publicIPAddresses_win01_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${vmName}-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}


@description('Create the network interface card')
resource networkInterfaces_win01_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${vmName}-nic01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_win01_resource.id
          }
          subnet: {
            id: subnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}


@description('Create virtual machine')
resource virtualMachines_win01_resource 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userIdentity}': {}
    }
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
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
      computerName: vmName
      adminUsername: username
      adminPassword: password
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_win01_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}
