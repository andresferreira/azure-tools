Login-AzureRmAccount

$clusterName = "<CLUSTER NAME>"
Remove-AzureRmHDInsightCluster -ClusterName $clusterName

Write-Host "Finish"
Read-Host "Press Enter to continue"
