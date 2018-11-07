#make sure you Azure Modules install - Command is below
#Install-Module -Name AzureRM -Force -Scope CurrentUser -AllowClobber
#Connect and test connection
Connect-AzureRmAccount
(Get-AzureRmLocation).Location

#Step 1: Create Key Vault and set flag to enable for template deployment with ARM
$rgname="<your initials> FileSyncLab"
New-AzureRmResourceGroup -Name $rgname -Location eastus 
$rg = Get-AzureRmResourceGroup -Name $rgname
$fsyncVaultName = 'fsyncVault'
New-AzureRmKeyVault -VaultName $fsyncVaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 2: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzureKeyVaultSecret -VaultName $fsyncVaultName -Name "DefaultPassword" -SecretValue (Get-Credential).Password

#Step 3: Update azuredeploy.parameters.json file in both sub folders with your Key Vault info example- /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
(Get-AzureRmKeyVault -VaultName $fsyncVaultName).ResourceId

#Change the parameters file and deploy
#Deply Active Directory Domain Controllers
$rg = Get-AzureRmResourceGroup -Name $rgname
$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
$template=".\active-directory-new-domain-ha-2-dc\azuredeploy.json"
$para=".\active-directory-new-domain-ha-2-dc\azuredeploy.parameters.json"
New-AzureRmResourceGroupDeployment `
  -Name $job `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile $template `
  -TemplateParameterFile $para

#Change the parameters file and deploy
#Deploy VM with multiple data disks and join domain
$rg = Get-AzureRmResourceGroup -Name $rgname
$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
$template=".\vm-multiple-data-disk-AD-Join\azuredeploy.json"
$para=".\vm-multiple-data-disk-AD-Join\azuredeploy.parameters.json"
New-AzureRmResourceGroupDeployment `
  -Name $job `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile $template `
  -TemplateParameterFile $para