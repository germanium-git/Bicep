# Parameters for Bicep template

The provisioning by bicep template refers to various parameters listed in the table below.

|  Parameter | type  |  Description | example  |
|---|---|---|---|
| vmName  |  string | Virtual machine name  | mysqlvm003  |
| azDeployment  | boolean  | true - deploys the VM to availability zone. <br /> false - deploys the VM to availability set  | true/false  |
| avSetName  | string  | Availability set name  | avset1  |
| faultDomainCount | integer | Number of fault domain in the availability set | 3 |
| updateDomainCount | integer | Number of update domain in the availability set | 3 |
| createAvailabilitySet | string | Yes - create a new avset. <br /> No - use an existing one | Yes/No |
| ppgName | string | Proximity Placement group | ppg1 |
 | createPpg | string | Yes - create a new ppg. </br> No - Use an existing ppg | Yes/No |
| avZone | string | Availability Zone | 1,2,3 |
| adminUsername | string | Local administrator account | vmadmin | 
| networkRg | string | The resource group of the vnet/subnet the VM is connected to. | rg-vnet |
| vnetName | string | Vnet name | myvnet |
| subnetName | string | Subnet name | default |
| privateIp | string | Static private IP address / Dynamic DHCP | dhcp/10.20.30.40 |
| enableAcceleratedNetworking | string | Enable accelerated networking | Yes/No |
| winVersion | string | Operating system | Windows Server 2016 Datacenter </br> Windows Server 2019 Datacenter </br> Windows Server 2019 Datacenter Server Core |
| vmSize | string | VM Size | Standard_DS3_v2 |
| useAHB | string | Use Azure Hybrid Benefit | Yes/No |
| timeZone | string Time Zone | (UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna |
| osDiskSuffix | string | Suffix to append to VM name to create os disk name | OsDisk | 
| AdditionalDiskSuffix | string | Suffix to append to VM name to create data disk name | DataDisk |
| osDiskStorageSku | string | Os disk SKU | Premium_LRS |
| dataDiskStorageSku | string | Data disk SKU | Premium_LRS |
| logDiskStorageSku | string | Log disk SKU | Premium_LRS |
| additionalDiskStorageSku | string | Additional disk SKU | Premium_LRS |
| NoOfDataDisks | integer | Number of data disks | 5 |
| dataDisksSize | integer | Data disk size in GB | 2048 |
| NoOfLogDisks | integer | Number of log disks | 2 |
| logDisksSize | integer | Data disk size in GB | 1024 |
| NoOfAdditionalDisks | integer | Number of additional disks | 1 |
| additionalDisksSize | integer | Additional disk size in GB | 16 |
| EnableSqlIaasExtension | string | Install SQL IaaS extension | Yes/No |
