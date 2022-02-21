targetScope = 'subscription'
param location string = 'westeurope'
param rgName string = 'rg-nemedpet-storage-privendpoint2'
param storageName string = 'sto20220218ah'
param containerName string = 'backup'
param privZoneName string = 'nemedpet.appservices.internal'
param vmName string = 'win01'
param userIdentityName string = 'sql-backup'
param username string = 'vmadmin'
param vnetName string = 'vnet-storage-privendpoint'
param vnetIpPrefix string = '10.100.0.0/16'

param subnetsConfig array = [
  {
    name: 'subnet10'
    range: '10.100.10.0/24'
  }
]

param storageFwipRules array =  [
  {
  value: '131.207.242.5'
  action: 'Allow'
  }
]


var subnet10Ref = vnet.outputs.subnets[0].id


// Create the resource group
resource appRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: location
}

// Create vnet & subnet
module vnet 'vnet.bicep' = {
  scope: appRG
  name: vnetName
  params: {
    vnetName: vnetName
    location: location
    vnetIpPrefix: vnetIpPrefix
    subnetsConfig: subnetsConfig
    nsgId: nsg.outputs.nsgId
  }
}

// Create the virtual machine
module vm 'vm.bicep' = {
  scope: appRG
  name: vmName
  params: {
    vmName: vmName
    username: username
    subnetId: subnet10Ref
    location: location
    userIdentity: userId.outputs.userIdentity
  }
}

// Create the user assigned identity
module userId 'identity.bicep' = {
 scope: appRG
 name: userIdentityName
 params:{
   userIdentityName: userIdentityName
   location: location
 }
}

// Create NSG and assign it to the subnet
module nsg 'nsg.bicep' = {
  scope: appRG
  name: '${rgName}-nsg'
  params:{
    name: '${rgName}-nsg'
    location: location
  }
}


module storage 'storage.bicep' = {
  scope: appRG
  name: storageName
  params:{
    storageName: storageName
    location: location
    storageFwipRules: storageFwipRules
    subnetId: subnet10Ref
    containerName: containerName
    privDnsZone: privZoneName
    vnetId: vnet.outputs.vnetId
  }
}
