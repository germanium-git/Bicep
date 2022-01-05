@description('The name for the Virtual Machine')
param vmName string
param avSetName string

@description('Number of fault domains')
param faultDomainCount int

@description('Number of update domains')
param updateDomainCount int

@description('Choose YES if the Availability Set specified before must be created by the template; choose NO if the Availability Set already exists')
@allowed([
  'Yes'
  'No'
])
param createAvailabilitySet string = 'Yes'
param ppgName string

@description('Choose YES if the Proximity Placemnet Group specified before must be created by the template; choose NO if the PPG already exists')
@allowed([
  'Yes'
  'No'
])
param createPpg string = 'Yes'

@description('Admin username for the Virtual Machine. If a domain is specified in the appropriate parameter, this user will be used both for local admin and to join domain')
param adminUsername string

@description('Admin password for the Virtual Machine')
@secure()
param adminPassword string = newGuid()

@description('Name of the resource group the vNet belongs to')
param networkRg string

@description('The vnet you want to connect to. Leave empty to create a new ad hoc virtual network')
@minLength(0)
@maxLength(100)
param vnetName string = ''

@description('The subnet you want to connect to')
param subnetName string = 'default'

@description('The private IP address you want to assign to the NIC; leave DHCP to maintain a dynamic IP')
param privateIp string = 'dhcp'

@description('Would you like to enable accelerated networking? It works only on supported VMs')
@allowed([
  'Yes'
  'No'
])
param enableAcceleratedNetworking string = 'Yes'

@description('The Windows server version you want to deploy')
@allowed([
  'Windows Server 2016 Datacenter'
  'Windows Server 2019 Datacenter'
  'Windows Server 2019 Datacenter Server Core'
])
param winVersion string = 'Windows Server 2019 Datacenter'

@description('The size of the virtual machine')
@allowed([
  'Standard_DS1'
  'Standard_DS2'
  'Standard_DS3'
  'Standard_DS4'
  'Standard_DS11'
  'Standard_DS12'
  'Standard_DS13'
  'Standard_DS14'
  'Standard_D1_v2'
  'Standard_D2_v2'
  'Standard_D3_v2'
  'Standard_D4_v2'
  'Standard_D5_v2'
  'Standard_D11_v2'
  'Standard_D12_v2'
  'Standard_D13_v2'
  'Standard_D14_v2'
  'Standard_D15_v2'
  'Standard_D2_v2_Promo'
  'Standard_D3_v2_Promo'
  'Standard_D4_v2_Promo'
  'Standard_D5_v2_Promo'
  'Standard_D11_v2_Promo'
  'Standard_D12_v2_Promo'
  'Standard_D13_v2_Promo'
  'Standard_D14_v2_Promo'
  'Standard_F1'
  'Standard_F2'
  'Standard_F4'
  'Standard_F8'
  'Standard_F16'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_DS5_v2'
  'Standard_DS11_v2'
  'Standard_DS12_v2'
  'Standard_DS13-2_v2'
  'Standard_DS13-4_v2'
  'Standard_DS13_v2'
  'Standard_DS14-4_v2'
  'Standard_DS14-8_v2'
  'Standard_DS14_v2'
  'Standard_DS15_v2'
  'Standard_DS2_v2_Promo'
  'Standard_DS3_v2_Promo'
  'Standard_DS4_v2_Promo'
  'Standard_DS5_v2_Promo'
  'Standard_DS11_v2_Promo'
  'Standard_DS12_v2_Promo'
  'Standard_DS13_v2_Promo'
  'Standard_DS14_v2_Promo'
  'Standard_F1s'
  'Standard_F2s'
  'Standard_F4s'
  'Standard_F8s'
  'Standard_F16s'
  'Standard_D2_v3'
  'Standard_D4_v3'
  'Standard_D8_v3'
  'Standard_D16_v3'
  'Standard_D32_v3'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32s_v3'
  'Standard_E2_v3'
  'Standard_E4_v3'
  'Standard_E8_v3'
  'Standard_E16_v3'
  'Standard_E32_v3'
  'Standard_E64_v3'
  'Standard_E2s_v3'
  'Standard_E4s_v3'
  'Standard_E8s_v3'
  'Standard_E16s_v3'
  'Standard_E32s_v3'
  'Standard_E64s_v3'
  'Standard_F2s_v2'
  'Standard_F4s_v2'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_F64s_v2'
  'Standard_F72s_v2'
  'Standard_H8'
  'Standard_H16'
  'Standard_H8m'
  'Standard_H16m'
  'Standard_H16r'
  'Standard_H16mr'
  'Standard_G1'
  'Standard_G2'
  'Standard_G3'
  'Standard_G4'
  'Standard_G5'
  'Standard_GS1'
  'Standard_GS2'
  'Standard_GS3'
  'Standard_GS4'
  'Standard_GS4-4'
  'Standard_GS4-8'
  'Standard_GS5'
  'Standard_GS5-8'
  'Standard_GS5-16'
  'Standard_L4s'
  'Standard_L8s'
  'Standard_L16s'
  'Standard_L32s'
  'Standard_E32-8s_v3'
  'Standard_E32-16s_v3'
  'Standard_E64-16s_v3'
  'Standard_E64-32s_v3'
  'Standard_A8'
  'Standard_A9'
  'Standard_A10'
  'Standard_A11'
])
param vmSize string = 'Standard_DS3_v2'

@description('Would you like to active Azure Hybrid Benefits and use an existing Windows license on this VM?')
@allowed([
  'Yes'
  'No'
])
param useAHB string = 'No'

@description('Choose the time zone for the virtual machine')
@allowed([
  '(UTC) Coordinated Universal Time'
  '(UTC+00:00) Dublin, Edinburgh, Lisbon, London'
  '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'
  '(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague'
  '(UTC+01:00) Brussels, Copenhagen, Madrid, Paris'
  '(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb'
  '(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius'
])
param timeZone string = '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'

@description('Suffix that will be used to compose OS disk name')
param osDiskSuffix string = 'OsDisk'

@description('Suffix that will be used to compose additional disk name')
param AdditionalDiskSuffix string = 'DataDisk'

@description('The type of storage to use for OS disk')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
  'UltraSSD_LRS'
])
param osDiskStorageSku string = 'Premium_LRS'

@description('The type of storage to use for Data Disks')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
  'UltraSSD_LRS'
])
param dataDiskStorageSku string = 'Premium_LRS'

@description('The number of data disks to add to the virtual machine')
param NoOfDataDisks int = 5

@description('The size of data disks to add to the virtual machine')
param dataDisksSize int = 2048

@description('The number of log disks to add to the virtual machine')
param NoOfLogDisks int = 3

@description('The size of log disks to add to the virtual machine')
param logDisksSize int = 1024

@description('The type of storage to use for Log Disks')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
  'UltraSSD_LRS'
])
param logDiskStorageSku string = 'Premium_LRS'

@description('The number of additional disks to add to the virtual machine')
param NoOfAdditionalDisks int = 0

@description('The size of additional disks to add to the virtual machine')
param additionalDisksSize int = 16

@description('The type of storage to use for Log Disks')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
  'UltraSSD_LRS'
])
param additionalDiskStorageSku string = 'Standard_LRS'

@description('Enable SQL IaaS Extension?')
@allowed([
  'Yes'
  'No'
])
param EnableSqlIaasExtension string = 'Yes'

var nicName_var = '${vmName}-nic1'
var vnetID = resourceId(networkRg, 'Microsoft.Network/virtualNetworks', vnetName)
var subnetRef = '${vnetID}/subnets/${toLower(subnetName)}'
var logDiskOffset = (NoOfDataDisks + 1)
var additonalDiskOffset = ((NoOfDataDisks + NoOfLogDisks) + 1)
var TimeZoneObj = {
  '(UTC) Coordinated Universal Time': {
    id: 'UTC'
  }
  '(UTC+00:00) Dublin, Edinburgh, Lisbon, London': {
    id: 'GMT Standard Time'
  }
  '(UTC+00:00) Monrovia, Reykjavik': {
    id: 'Greenwich Standard Time'
  }
  '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna': {
    id: 'W. Europe Standard Time'
  }
  '(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague': {
    id: 'Central Europe Standard Time'
  }
  '(UTC+01:00) Brussels, Copenhagen, Madrid, Paris': {
    id: 'Romance Standard Time'
  }
  '(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb': {
    id: 'Central European Standard Time'
  }
  '(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius': {
    id: 'FLE Standard Time'
  }
}
var diskattachAll = union(diskAttach, logdiskAttach, additinaldiskAttach)
var winVersionObj = {
  'Windows Server 2016 Datacenter': {
    offer: 'WindowsServer'
    sku: '2016-Datacenter'
  }
  'Windows Server 2019 Datacenter': {
    offer: 'WindowsServer'
    sku: '2019-Datacenter'
  }
  'Windows Server 2019 Datacenter Server Core': {
    offer: 'WindowsServer'
    sku: '2019-Datacenter-Core'
  }
}
var diskAttach = [for i in range(0, NoOfDataDisks): {
  name: '${vmName}-${AdditionalDiskSuffix}${string((i + 1))}'
  createOption: 'attach'
  caching: 'ReadOnly'
  lun: (i + 1)
  managedDisk: {
    id: resourceId('Microsoft.Compute/disks', '${vmName}-${AdditionalDiskSuffix}${string((i + 1))}')
  }
}]
var logdiskAttach = [for i in range(0, NoOfLogDisks): {
  name: '${vmName}-${AdditionalDiskSuffix}${string((i + logDiskOffset))}'
  createOption: 'attach'
  caching: 'none'
  lun: (i + logDiskOffset)
  managedDisk: {
    id: resourceId('Microsoft.Compute/disks', '${vmName}-${AdditionalDiskSuffix}${string((i + logDiskOffset))}')
  }
}]
var additinaldiskAttach = [for i in range(0, NoOfAdditionalDisks): {
  name: '${vmName}-${AdditionalDiskSuffix}${string((i + additonalDiskOffset))}'
  createOption: 'attach'
  caching: 'none'
  lun: (i + additonalDiskOffset)
  managedDisk: {
    id: resourceId('Microsoft.Compute/disks', '${vmName}-${AdditionalDiskSuffix}${string((i + additonalDiskOffset))}')
  }
}]

resource nicName 'Microsoft.Network/networkInterfaces@2017-09-01' = {
  name: nicName_var
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: ((toLower(privateIp) == 'dhcp') ? 'Dynamic' : 'Static')
          privateIPAddress: ((toLower(privateIp) == 'dhcp') ? json('null') : privateIp)
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    enableAcceleratedNetworking: ((toLower(enableAcceleratedNetworking) == 'yes') ? bool('true') : bool('false'))
  }
}

resource vmName_resource 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    licenseType: ((toLower(useAHB) == 'yes') ? 'Windows_Server' : 'None')
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        timeZone: TimeZoneObj[timeZone].id
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: winVersionObj[winVersion].offer
        sku: winVersionObj[winVersion].sku
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        name: '${vmName}-${osDiskSuffix}'
        managedDisk: {
          storageAccountType: osDiskStorageSku
        }
      }
      dataDisks: diskattachAll
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
    availabilitySet: {
      id: avSetName_resource.id
    }
    proximityPlacementGroup: {
      id: ppgName_resource.id
    }
  }
  dependsOn: [
    vmName_AdditionalDiskSuffix_dataDisks_1
    vmName_AdditionalDiskSuffix_logDisks_logDiskOffset
  ]
}

resource vmName_AdditionalDiskSuffix_dataDisks_1 'Microsoft.Compute/disks@2020-09-30' = [for i in range(0, NoOfDataDisks): if (NoOfDataDisks > 0) {
  name: '${vmName}-${AdditionalDiskSuffix}${string((i + 1))}'
  location: resourceGroup().location
  properties: {
    diskSizeGB: dataDisksSize
    creationData: {
      createOption: 'Empty'
    }
  }
  sku: {
    name: dataDiskStorageSku
  }
}]

resource vmName_AdditionalDiskSuffix_logDisks_logDiskOffset 'Microsoft.Compute/disks@2020-09-30' = [for i in range(0, NoOfLogDisks): if (NoOfLogDisks > 0) {
  name: '${vmName}-${AdditionalDiskSuffix}${string((i + logDiskOffset))}'
  location: resourceGroup().location
  properties: {
    diskSizeGB: logDisksSize
    creationData: {
      createOption: 'Empty'
    }
  }
  sku: {
    name: logDiskStorageSku
  }
}]

resource vmName_AdditionalDiskSuffix_additionalDisks_additonalDiskOffset 'Microsoft.Compute/disks@2020-09-30' = [for i in range(0, NoOfAdditionalDisks): if (NoOfAdditionalDisks > 0) {
  name: '${vmName}-${AdditionalDiskSuffix}${string((i + additonalDiskOffset))}'
  location: resourceGroup().location
  properties: {
    diskSizeGB: additionalDisksSize
    creationData: {
      createOption: 'Empty'
    }
  }
  sku: {
    name: additionalDiskStorageSku
  }
}]

resource avSetName_resource 'Microsoft.Compute/availabilitySets@2018-10-01' = if (toLower(createAvailabilitySet) == 'yes') {
  name: avSetName
  location: resourceGroup().location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: faultDomainCount
    platformUpdateDomainCount: updateDomainCount
    proximityPlacementGroup: {
      id: ppgName_resource.id
    }
  }
}

resource ppgName_resource 'Microsoft.Compute/proximityPlacementGroups@2019-03-01' = if (toLower(createPpg) == 'yes') {
  name: ppgName
  location: resourceGroup().location
  properties: {
    proximityPlacementGroupType: 'Standard'
  }
}

resource vmName_SqlIaasExtension 'Microsoft.Compute/virtualMachines/extensions@2015-06-15' = if ((toLower(EnableSqlIaasExtension) == 'yes') ? bool('true') : bool('false')) {
  parent: vmName_resource
  name: 'SqlIaasExtension'
  location: resourceGroup().location
  properties: {
    type: 'SqlIaaSAgent'
    publisher: 'Microsoft.SqlServer.Management'
    typeHandlerVersion: '1.2'
    autoUpgradeMinorVersion: true
    settings: {
      AutoTelemetrySettings: {
        Region: resourceGroup().location
      }
    }
  }
}
