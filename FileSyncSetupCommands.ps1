#Step 1:
Install-Module -Name AzureRM -Force -Scope CurrentUser -AllowClobber

#Step 2: Link to install Agent for File Sync - https://go.microsoft.com/fwlink/?linkid=858257

#Step 3: Install packagemanagement and powershellget
Install-Module -Name PackageManagement -Repository PSGallery -Force -Scope CurrentUser -AllowClobber
Install-Module -Name PowerShellGet -Repository PSGallery -Force -Scope CurrentUser -AllowClobber

#Step 4: make sure you close and re-open powershell
Install-Module -Name AzureRM.StorageSync -AllowPrerelease -Scope CurrentUser

#Step 5: Test compatiblity with file sync
Invoke-AzureRmStorageSyncCompatibilityCheck -Path "<your fileshare path>"

#Test just computer
Invoke-AzureRmStorageSyncCompatibilityCheck -ComputerName localhost

#Step 6: Register Server with file sync as endpoint
#register Sync Server endpoint
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.PowerShell.Cmdlets.dll"
Login-AzureRmStorageSync -SubscriptionID "<your subscription Id>"
Register-AzureRmStorageSyncServer -SubscriptionId "<your subscription Id>" -ResourceGroupName "<your rg name>" -StorageSyncService "<your storage sync service name>" 

#to remove from file sync
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll"
Invoke-StorageSyncFileRecall -Path "<your fileshare path>" 

