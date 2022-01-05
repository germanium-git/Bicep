# Data Collection Rule

The template creates the new data collection rule for monitoring the performance metrics specified in the template for Windows servers to be sent to Azure Monitor.
An existing server is associated with the rule as part of the template deployment.

The Example of use:

```shell
az deployment group create --name dcrule --resource-group rg-nemedpet-kvstorage --template-file dcrule.bicep
```
