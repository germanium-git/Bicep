# Virtual Machine with multiple data disks

## Description

The template may be used for creating a virtual machine with multiple data disks. VM can have zero or several data disks. Each disk have their options (size, SKU etc.) and when you attach them you may also specify caching.
In this template as part of the virtual machine deployment three types of data disks are created:
- data disks
- log disks
- additional disks

Each type is represented with the parameters specifying number of disks, SKU, size and caching.

The virtual machine created by the template is supposed to be placed into a proximity placement group in an availability set that also may be created by template. Whether or not the availability set and proximity placement groups are created depends on the parameters createAvailabilitySet and createPpg. In such a way multiple VMs can be created while being put into the same proximity group and which can be further on used for forming clusters.

## Notice

The template can use the virtual network and subnet from different resource group.
If this is needed than add the following parameter into parameters. By default it takes the name of the RG where the resources are created.

```
    "networkRg": {
        "value": "mynetwork-rg"
    },
```

## Deploy the VM

```shell
az deployment group create --name VM --resource-group rg-nemedpet-kvstorage --template-file vm_sql_multiple_disks.bicep  --parameters vm_sql_multiple_disks_params.json
```

## Deploy test vNet & Subnet

```shell
az deployment group create --name vnet --resource-group rg-nemedpet-kvstorage --template-file vnet.bicep
```

## Result

As an example see the virtual machine created by the template that consist of the following data disks:

<img src="pictures/datadisks.PNG" width="800">