# Storage account with the private endpoint

The template creates the storage account and virtual machine that is configured with user's defined managed identity and can access the storage account.

```shell
az deployment sub create --location 'westeurope' --template-file main.bicep
```

After the VM is created you can run the script [UploadFiles.ps1](UploadFiles.ps1) to upload files to the storage account. Remember to install Az module first to make the script work.

## TODO

Add custom script extension to install the Az PowerShell module.

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```
