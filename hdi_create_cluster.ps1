$subscriptionID = <SUBSCRIPTION ID>
# Get information for the HDInsight cluster
$clusterName = "<CLUSTER NAME>"			
$password = "<PASSWORD>"	
$resourceGroupName = "<RESOURCE GROUP NAME>" 																				
$location = "West Europe" 																								
$defaultStorageAccountName = "<DEFAULT STORAGE ACCOUNT NAME>" 
$defaultStorageAccountKey = "<DEFAULT STORAGE ACCOUNT KEY>"
$clusterSizeInNodes = "2" 
$clusterVersion = "3.6"
$clusterType = "Spark" #Creates a Spark cluster by default, but this value can be changed
$clusterOS = "Linux"
$defaultBlobContainerName = $clusterName # Set the storage container name to the cluster name
$UserNameHttp = "admin"
$UserNameSsh = "sshuser"

#################################################################################################################################################
# Login to your Azure subscription
# Is there an active Azure subscription?
$sub = Get-AzureRmSubscription -ErrorAction SilentlyContinue
if(-not($sub))
{
    Add-AzureRmAccount
}

# If you have multiple subscriptions, set the one to use
Select-AzureRmSubscription -SubscriptionId $subscriptionID

# Create an Azure Storage account and container
$defaultStorageContext = New-AzureStorageContext `
                                -StorageAccountName $defaultStorageAccountName `
                                -StorageAccountKey $defaultStorageAccountKey
								
# Create a BLOB container. This holds the default data store for the cluster.
New-AzureStorageContainer -Name $clusterName -Context $defaultStorageContext 
															
# Cluster login is used to secure HTTPS services hosted on the cluster
$PWord = ConvertTo-SecureString -String $password -AsPlainText -Force		
$httpCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserNameHttp, $PWord
$sshCredentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserNameSsh, $PWord # SSH user is used to remotely connect to the cluster using SSH clients
	
# Create the HDInsight cluster
New-AzureRmHDInsightCluster `
    -ResourceGroupName $resourceGroupName `
    -ClusterName $clusterName `
    -Location $location `
    -ClusterSizeInNodes $clusterSizeInNodes `
    -ClusterType $clusterType `
    -OSType $clusterOS `
    -Version $clusterVersion `
    -HttpCredential $httpCredential `
    -DefaultStorageAccountName "$defaultStorageAccountName.blob.core.windows.net" `
    -DefaultStorageAccountKey $defaultStorageAccountKey `
    -DefaultStorageContainer $clusterName `
    -SshCredential $sshCredentials
							
Write-Host "Finish"
Read-Host "Press Enter to continue"

#################################################################################################################################################
# SOME DOCUMENTATION:
# https://docs.microsoft.com/en-us/powershell/module/azurerm.hdinsight/new-azurermhdinsightcluster?view=azurermps-4.1.0
# https://docs.microsoft.com/en-us/powershell/module/azure/?view=azuresmps-4.0.0
# https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-create-linux-clusters-azure-powershell
# Get-Credential documentation: https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.security/get-credential?f=255&MSPPError=-2147217396