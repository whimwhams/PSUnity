$Session = New-PSUnitySession -ComputerName localhost -Port 7777

# servers
Set-PSUnityServer -Session $Session -X 30 -Y 30 -Name smallFiler -Role Filer -Location Ajaccio -Status 2 -Description "Sunny" -Type 2 
Set-PSUnityServer -Session $Session -X -30 -Y 5 -Name Server1 -Role FIM -Location NY -Status 4 -Description "Server1 is down" 


Set-PSUnityServer -Session $Session -X -20 -Y 5 -Name Server3 -Role IIS -Location Madrid -Status 3 -Description "Server2 has its CPU exceed 90% threshold" 
Set-PSUnityServer -Session $Session -X -10 -Y 5 -Name LYNC1 -Role Lync -Location LV-426 -Status 0 -Description "LYNC1 needs to be rebooted." 

Set-PSUnityServer -Session $Session -X 0 -Y 5 -Name EXSRV1 -Role Exchange -Location Maui -Status 0 -Description "EXSRV1 has drifted its configuration." 
Set-PSUnityServer -Session $Session -X 10 -Y 5 -Name DC1 -Role "DC" -Location "Redmond" -Status 0 -Description "DC1 does not have a configuration." 
Set-PSUnityServer -Session $Session -X 20 -Y 5 -Name DC2 -Role DC -Location Redmond -Status 1 -Description "DC2 did not replicate in over a week." 
Set-PSUnityServer -Session $Session -X 30 -Y 5 -Name DC3 -Role DC -Location Singapore -Status 2 -Description "DC3 is fine." 

Set-PSUnityServer -Session $Session -X -30 -Y 20 -Name NAS1 -Role "Usr files" -Location Paris -Status 3 -Description "NAS1 does not have a configuration." -Type 1

# sites
Set-PSUnitySite -Session $Session -name "Some Servers" -X 0 -Y 20 -Width 13 -Height 7

# cities
Set-PSUnityCity -Session $Session -Name Milan -Status 1 -Description "DC is fine"
Set-PSUnityCity -Session $Session -Name Rome -Status 2 -Description "DC configuration has drifted"
Set-PSUnityCity -Session $Session -Name Paris -Status 0 -Description "a description"
Set-PSUnityCity -Session $Session -Name Brussels -Status 4 -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name Amsterdam -Status 4 -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name London -Status 1
Set-PSUnityCity -Session $Session -Name Dublin -Status 2 -Description "hello world"
Set-PSUnityCity -Session $Session -Name Madrid -Status 3 -Description "DSC Configuration not found"
Set-PSUnityCity -Session $Session -Name Barcelona -Status 0
Set-PSUnityCity -Session $Session -Name Lisbon -Status 1 -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name Tokyo -Status 2 -Description "Replication latency"
Set-PSUnityCity -Session $Session -Name Stockholm -Status 3 -Description "Error during DSC configuration" 
Set-PSUnityCity -Session $Session -Name Seattle -Status 2
Set-PSUnityCity -Session $Session -Name Sydney -Status 1
Set-PSUnityCity -Session $Session -Name Houston -Status 4  -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name Beijing -Status 0
Set-PSUnityCity -Session $Session -Name Oslo -Status 0
Set-PSUnityCity -Session $Session -Name Helsinki -Status 1
Set-PSUnityCity -Session $Session -Name Copenhagen -Status 4 -Description "DC memory is beyond threshold"
Set-PSUnityCity -Session $Session -Name Munich -Status 0
Set-PSUnityCity -Session $Session -Name Berlin -Status 4 -Description "CPU is 100%"
Set-PSUnityCity -Session $Session -Name Dubai -Status 0
Set-PSUnityCity -Session $Session -Name Bangalore -Status 0
Set-PSUnityCity -Session $Session -Name Mumbai -Status 0
Set-PSUnityCity -Session $Session -Name Singapore -Status 0
Set-PSUnityCity -Session $Session -Name "Hong Kong" -Status 0 -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name Beijing -Status 0
Set-PSUnityCity -Session $Session -Name Tokyo -Status 0
Set-PSUnityCity -Session $Session -Name Osaka -Status 0 
Set-PSUnityCity -Session $Session -Name "Abu Dhabi" -Status 0 
Set-PSUnityCity -Session $Session -Name Mumbai -Status 0 -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name "New York" -Status 0 
Set-PSUnityCity -Session $Session -Name "San Francisco" -Status 0 
Set-PSUnityCity -Session $Session -Name Montreal -Status 0
Set-PSUnityCity -Session $Session -Name Dallas -Status 0
Set-PSUnityCity -Session $Session -Name "Sao Paulo" -Status 0 -Description "DC does not respond"
Set-PSUnityCity -Session $Session -Name Frankfurt -Status 1
Set-PSUnityCity -Session $Session -Name Moscow -Status 2
Set-PSUnityCity -Session $Session -Name "Saint Petersburg" -Status 0
Set-PSUnityCity -Session $Session -Name Taipei -Status 3 -Description "60% of resources failed"
Set-PSUnityCity -Session $Session -Name Shanghai -Status 0
Set-PSUnityCity -Session $Session -Name Seoul -Status 0
Set-PSUnityCity -Session $Session -Name Chicago -Status 4 -Description "DC does not respond"

# Galaxy
Set-PSUnityGalaxy -Session $Session -Name DataCenter1 -Stars 500 -Description "Main Production Datacenter"

# Domains
Set-PSUnityDomain -Session $Session -Name ad.local -Status 4 -Description "no ping from the domain"
Set-PSUnityDomain -Session $Session -Name emea.ad.local -Status 3 -Description "2 DCs drifted their DSC configuration"
Set-PSUnityDomain -Session $Session -Name asia.ad.local -Status 2 -Description "domain responds to ping"


# Data Centre

Set-PSUnityCloudInfo -Session $Session -Site 1 -Name "Data Center 1" -Role "Active" -Location "Main Data Center" -Status 1 
Set-PSUnityCloudInfo -Session $Session -Site 2 -Name "Data Center 2" -Role "Standby" -Location "Backup Data Center" -Status 4

$color = 4
for ($i = 0; $i -lt 1500; $i++)
{
	
	Set-PSUnityCloud -Session $Session -Site 1 -Name "VM$i" -VMHost "Hostname" -Cluster "ClusterID" -Status $color  -Description Running
	$color++;
	if ($color -eq 5)
	{
		$color = 0
	}
}





Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM1" -VMHost "Hostname" -Cluster "ClusterID" -Status 5  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM2" -VMHost "Hostname" -Cluster "ClusterID" -Status 5  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM3" -VMHost "Hostname" -Cluster "ClusterID" -Status 5  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM4" -VMHost "Hostname" -Cluster "ClusterID" -Status 5  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM5" -VMHost "Hostname" -Cluster "ClusterID" -Status 5  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM6" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 

Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM7" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM8" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM9" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM10" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM11" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM12" -VMHost "Hostname" -Cluster "ClusterID" -Status 5 

sleep -Seconds 10

Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM1" -VMHost "Hostname" -Cluster "ClusterID" -Status 0
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM2" -VMHost "Hostname" -Cluster "ClusterID" -Status 0  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM3" -VMHost "Hostname" -Cluster "ClusterID" -Status 0  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM4" -VMHost "Hostname" -Cluster "ClusterID" -Status 0  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM5" -VMHost "Hostname" -Cluster "ClusterID" -Status 0  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM6" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 

Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM7" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM8" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM9" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM10" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM11" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM12" -VMHost "Hostname" -Cluster "ClusterID" -Status 0 

sleep -Seconds 10

Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM1" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 -Description "shutting down"
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM2" -VMHost "Hostname" -Cluster "ClusterID" -Status 6  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM3" -VMHost "Hostname" -Cluster "ClusterID" -Status 6  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM4" -VMHost "Hostname" -Cluster "ClusterID" -Status 6  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM5" -VMHost "Hostname" -Cluster "ClusterID" -Status 6  
Set-PSUnityCloud -Session $Session -Site 1 -Name "StartingVM6" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 

Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM7" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM8" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM9" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM10" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM11" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 
Set-PSUnityCloud -Session $Session -Site 2 -Name "StartingVM12" -VMHost "Hostname" -Cluster "ClusterID" -Status 6 

Add-PSUnityEvent -Session $Session -Name "Paris" -Status 4 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") Administrator André S. added user Gary B. in group SRV1\Administrators"
Add-PSUnityEvent -Session $Session -Name "Seattle" -Status 1 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") User Jane N. got locked out from computer LAPTOP1"
Add-PSUnityEvent -Session $Session -Name "Singapore" -Status 2 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") Administrator Sean N. created group AD\GROUP1"
Add-PSUnityEvent -Session $Session -Name "San Francisco" -Status 3 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") Administrator Neal N. created group AD\READGROUP1"
Add-PSUnityEvent -Session $Session -Name "Rome" -Status 4 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") Administrator Jack L. removed user Kate H. from group AD\WEBACCESS"
Add-PSUnityEvent -Session $Session -Name "Tokyo" -Status 0 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") Administrator Robert C. created computer object SRV2"
Add-PSUnityEvent -Session $Session -Name "Dubai" -Status 1 -Description "$(Get-Date -Format "dd/MMM/yyyy HH:mm:ss") This is an event"

Add-PSUnityEventOccurrence -Session $Session -Account "AD\John" -NumEvents "34508345"
Add-PSUnityEventOccurrence -Session $Session -Account "AD\Marc" -NumEvents "2342364"
Add-PSUnityEventOccurrence -Session $Session -Account "AD\Anne" -NumEvents "234564"
Add-PSUnityEventOccurrence -Session $Session -Account "AD\Ava" -NumEvents "102654"
Add-PSUnityEventOccurrence -Session $Session -Account "AD\ServiceAccount1" -NumEvents "34345"
Add-PSUnityEventOccurrence -Session $Session -Account "SRV\administrator" -NumEvents "23234"
Add-PSUnityEventOccurrence -Session $Session -Account "ServiceAccount2" -NumEvents "2344"
Add-PSUnityEventOccurrence -Session $Session -Account "ServiceAccount3" -NumEvents "1024"
Add-PSUnityEventOccurrence -Session $Session -Account "ServiceAccount4" -NumEvents "10"
Add-PSUnityEventOccurrence -Session $Session -Account "ServiceAccount5" -NumEvents "1"

Add-PSUnityEventOccurrence -Session $Session -Server "DC1" -NumEvents "345345"
Add-PSUnityEventOccurrence -Session $Session -Server "DC2" -NumEvents "234234"
Add-PSUnityEventOccurrence -Session $Session -Server "DC3" -NumEvents "2344"
Add-PSUnityEventOccurrence -Session $Session -Server "DC4" -NumEvents "1024"

Remove-PSUnitySession -Session $Session