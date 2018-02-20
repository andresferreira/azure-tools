$subscriptionID = <SUBSCRIPTION ID>
$dataLakeStoreName = <DATA LAKE STORE NAME>
$myrootdir = "/" #CHANGE ONLY if you want to see more details on a certain directory (example: "/catalog")  

# Login to your Azure subscription
# Is there an active Azure subscription?
$sub = Get-AzureRmSubscription -ErrorAction SilentlyContinue
if(-not($sub))
{
    Add-AzureRmAccount
}

# If you have multiple subscriptions, set the one to use
Select-AzureRmSubscription -SubscriptionId $subscriptionID

############################################################
Function CalculateSize([string]$directoryName)
{
    $global:countglobal = 0
	$directory = Get-AzureRmDataLakeStoreChildItem -AccountName $dataLakeStoreName -Path $directoryName
	Foreach ($item in $directory)
	{
		if($item.Type -eq "FILE")
		{
			$countglobal = $item.Length + $countglobal
		}
		elseif($item.Type -eq "DIRECTORY")
		{ 
            $countglobal = CalculateSize($item.Path) + $countglobal
		}
	}
	return $countglobal
}

########################## MAIN CODE ##################################
$rootDirectory = Get-AzureRmDataLakeStoreChildItem -AccountName $dataLakeStoreName -Path $myrootdir
$countTotal = 0
Foreach ($item in $rootDirectory)
{
    $size = CalculateSize($item.Path)
	$countTotal = $size + $countTotal
    Write-Host $item.Path - ($size/1MB) "MiB"
}
Write-Host Total = ($countTotal/1GB) "GiB" in $myrootdir directory