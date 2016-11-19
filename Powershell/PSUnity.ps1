<#
    PSUnity is a Powershell interface to Unity, displaying information such as the status and description 
	of various nodes in an infrastructure.
	PSUnity can be used, for example, to display nodes that drifted their DSC configuration, or the Active Directory replication topology.

    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli micky@balladelli.com
	Blog		: https://balladelli.com
	
	
	Example:
	
		$Session = New-PSUnitySession -ComputerName localhost -Port 7777
		Add-PSUnityServer -Session $Session -X -30 -Y 5 -Name Server1 -Role IIS -Location Paris -Status 3 -Description "When it's broken, we light up the BBQ." 
		Add-PSUnityServer -Session $Session -X -20 -Y 5 -Name Server2 -Role IIS -Location Madrid -Status 4 -Description "Someone used Write-Host, and this puppy died." 
		Add-PSUnityServer -Session $Session -X -10 -Y 5 -Name LYNQ1 -Role Lynq -Location LV-426 -Status 1 -Description "When in trouble, fear, or doubt - run in circles, scream, and shout." 
		Add-PSUnityServer -Session $Session -X 0 -Y 5 -Name EXSRV1 -Role Exchange -Location Maui -Status 2 -Description "You are asking for a cyber-punch to the face." 
		Add-PSUnityServer -Session $Session -X 10 -Y 5 -Name DC1 -Role "We truly wonder" -Location NoIdea -Status 3 -Description "SSH has the risk profile of a 1980s San Francisco bathhouse - way too much anonymous sharing." 
		Add-PSUnityServer -Session $Session -X 20 -Y 5 -Name DC2 -Role DC -Location Redmond -Status 4 -Description "You my friend are not a Rock Star." 
		Add-PSUnityServer -Session $Session -X 30 -Y 5 -Name DC3 -Role DC -Location Outatime -Status 0 -Description "Did you just lick on my cookie?" 
		Remove-PSUnitySession -Session $Session	

	PS. All the example descriptions courtesy of Jeffrey Snover.
	
	TCP client/server authentication code is modified from the example provided by Boe Prox (http://learn-powershell.net/2014/02/22/building-a-tcp-server-using-powershell/)
#>
<#  
.SYNOPSIS  
	New-PSUnitySession creates a session to a Unity server 

.DESCRIPTION  
 	Creates a new PSUnity Session.
        
 
.PARAMETER ComputerName
	Computer where Unity is running. Note that the Unity program must have 'Accept Powershell Connections' selected

.PARAMETER Port
    Port to use, by default 7777
 
.EXAMPLE
    $session = New-PSUnitySession -ComputerName localhost 
 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function New-PSUnitySession
{
	[CmdletBinding()]
	param(
			[string] $ComputerName = "localhost",
			[int32]  $Port = 7777
			#[PSCredential] $Credential
		 )

	begin
	{
		$client = New-Object System.Net.Sockets.tcpClient -ArgumentList $ComputerName,"$port"
	}
	process
	{
		if ($client.Connected)
		{
			$stream = $client.GetStream()
			
			# Keep the following commented out until Unity supports NegotiateStream.
			#
			#$NegotiateStream =  New-Object net.security.NegotiateStream -ArgumentList $stream

			#Try 
			#{
			#	if ($Credential)
			#	{
			#	    $NegotiateStream.AuthenticateAsClient(
			#	        $Credential,
			#	        "PSUNITY\$($Env:computername)",
			#	        [System.Net.Security.ProtectionLevel]::EncryptAndSign,
			#	        [System.Security.Principal.TokenImpersonationLevel]::Identification
			#	    )
			#	}
			#	else
			#	{
			#		$NegotiateStream.AuthenticateAsClient(
			#	        [System.Net.CredentialCache]::DefaultNetworkCredentials,
			#	        "PSUNITY\$($Env:computername)",
			#	        [System.Net.Security.ProtectionLevel]::EncryptAndSign,
			#	        [System.Security.Principal.TokenImpersonationLevel]::Impersonation				
			#			)
			#	}
			#} 
			#Catch 
			#{
			#    Write-Warning $_.Exception.Message
			#} 
					
			$writer = New-Object System.IO.StreamWriter $stream
			$writer.AutoFlush = $true
		}
		else
		{
			return $null
		}

		$UnitySession = New-Object -TypeName PSCustomObject -Property @{
						Client				= $client;
						Stream				= $stream;
						Writer				= $writer
					}
		
	}
	end
	{
		$UnitySession
	}
}
<#  
.SYNOPSIS  
	Remove-PSUnitySession ends a session to a Unity server 

.DESCRIPTION  
  	Remove-PSUnitySession ends a session previously created with New-PSUnitySession.
 
.PARAMETER Session
	Session to remove.
 
.EXAMPLE
    Remove-PSUnitySession -Session $session 
 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Remove-PSUnitySession
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session
		 )

	process
	{	
		if ($Session)
		{
			$Session.Writer.Dispose()
			$Session.Client.Close()
		}
	}
}

<#  
.SYNOPSIS  
	Set-PSUnityServer adds or modifies a server to Unity servers view

.DESCRIPTION  
     
	A server is defined by a unique name, a role, a location, a status, description, coordinates (X, Y), and a rotation.
        
 
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the server to add/modify. The name of the server must be unique.

.PARAMETER Role
	Role of the server
	
.PARAMETER Location
	Location of the server, for example Paris, or Computer Room 123.

.PARAMETER Status
	Status of the server, can be a number between 0 and 4. 
		0 meaning no errors
		1 could mean that the server needs a reboot
		2 Warning status (sparks)
		3 Error status (smoke)
		4 Critical error status (burning fire)

.PARAMETER Description
	Description of the server or information that R2D2 will display when it reaches the server.
	
.PARAMETER X
	Coordinate X of the server.

.PARAMETER Y
	Coordinate Y of the server (really this is Z in Unity, but for simplicity we're 
	using a 2D coordinate system in Powershell, and Unity will transfor it to 3D).

.PARAMETER Rotation
 	Defines the angle of rotation of the server.
	
.PARAMETER Type
 	Type of server or the ID of the prefab that will be used to instantiate the server object, can be 0, 1 or 2.
	
.EXAMPLE
    Set-PSUnityServer 
 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnityServer
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Role,
            [string] $Location,
			[Int32]  $Status = 1,
            [string] $Description,
            [int32]  $X,
            [int32]  $Y,
			[Int32]  $Rotation = 0,
			[Int32]  $Type = 0
		)
	
	process
	{
		$command = "SERVER_1.0;$X;$Y;$Rotation;$Name;$Role;$Location;$Status;$Type;$Description"
		$Session.Writer.WriteLine($command)
	}
}


<#  
.SYNOPSIS  
	Set-PSUnitySite adds a site to Unity 

.DESCRIPTION  
 
    Adds a site to Unity. A site is a platform containing servers.
	A site is defined by a name, location, description, coordinates (X, Y), and a rotation.
        
 
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the site to add/modify. The name of the site must be unique.
	
.PARAMETER Location
	Location of the site, for example Paris, or Computer Room 123.

.PARAMETER Description
	Description of the site. This information is used if the site needs to highlight status information.
	
.PARAMETER X
	Coordinate X of the site.

.PARAMETER Y
	Coordinate Y of the site (really this is Z in Unity, but for simplicity we're 
	using a 2D coordinate system in Powershell, and Unity will transfor it to 3D).

.PARAMETER Width
	Site Width as a Float value. 1.0 is the default width.

.PARAMETER Height
	Site Width as a Float value. 1.0 is the default height.

.PARAMETER Rotation
 	Defines the angle of rotation of the site.
	
.EXAMPLE
    Set-PSUnitySite 
 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnitySite
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Location,
            [string] $Description,
            [int32]  $X,
            [int32]  $Y,
            [Float]  $Width = 1.0,
            [Float]  $Height = 1.0,			
			[Int32]  $Rotation = 0
		)
	
	process
	{
		$command = "SITE_1.0;$X;$Y;$Width;$Height;$Rotation;$Name;$Location;$Description"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Set-PSUnityCity sets the city state in Unity 

.DESCRIPTION  
 
    Set-PSUnityCity sets the city state in Unity's Globe view
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the city

.PARAMETER Status
	Status of the city, can be a number between 0 and 4. 
		0 Green, meaning no errors
		1 Blue, could mean that a server in this city needs a reboot
		2 Yellow, Warning status 
		3 Orange, Error status
		4 Red, Critical error status 	

.PARAMETER Description
	Description of the city. This information is displayed when the mouse passes over the city or in the console.
	
	
.EXAMPLE
	 Set-PSUnityCity -Session $Session -Name Paris -Status 4 -Description "SRV55 does not respond"
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnityCity
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [ValidateSet('Rome','Milan','Paris','London','Brussels','Amsterdam','Madrid','Barcelona','Lisbon','Stockholm','Oslo',
			'Helsinki','Copenhagen','Munich','Berlin','Dublin','Dubai','Bangalore','Mumbai','Singapore','Hong Kong','Beijing','Tokyo',
			'Sydney','San Francisco','Seattle','New York','Miami','Houston','Abu Dhabi','Montreal','Dallas','Sao Paulo','Osaka','Frankfurt',
			'Moscow','Saint Petersburg','Taipei','Shanghai','Chicago','Seoul')][string] $Name,
            [string] $Status,
            [string] $Altname = "",
            [string] $Description
		)
	
	process
	{
		$command = "CITY_1.0;$Name;$Status;$Altname;$Description"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Set-PSUnityGalaxy creates or modifies a galaxy in Unity 

.DESCRIPTION  
 
    Set-PSUnityGalaxy creates a galaxy in Unity where each star represents a node in a cloud of systems.
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the galaxy

.PARAMETER Stars
	Number of stars in the galaxy

.PARAMETER Description
	Description of the galaxy. Could be the location of the datacenter, role, etc.
	
	
.EXAMPLE
	 New-PSUnityGalaxy -Session $Session -Name DataCenter1 -Stars 2000 -Description "Main Production Datacenter"
	 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnityGalaxy
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Stars = "1500",
            [string] $Dust = "5000", #3000
            [string] $Description,
			[string] $GalaxyRadius = "9000",
			[string] $CoreRadius = "1500",
			[string] $AngularOffset = "0.0003", 
			[string] $CoreExcentricity = "1.45",
			[string] $EdgeExcentricity = "0.7"			
		)
	
	process
	{
		$command = "GALAXY_1.0;$Name;$Stars;$Description;$GalaxyRadius;$CoreRadius;$AngularOffset;$CoreExcentricity;$EdgeExcentricity;$Dust;H2stars"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Set-PSUnityDomain adds or modifies a domain status in Unity 

.DESCRIPTION  
 
    Set-PSUnityDomain adds or modifies a domain status in Unity's Globe view
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the domain

.PARAMETER Status
	Status of the domain, can be a number between 0 and 4. 

.PARAMETER Description
	Description of the domain. 
	
	
.EXAMPLE
	 Set-PSUnityDomain -Session $Session -Name MyDomain -Status 0 -Description "domain responds to ping"
	 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnityDomain
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Status,
            [string] $Description
		)
	
	process
	{
		$command = "DOMAIN_1.0;$Name;$Status;$Description"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Set-PSUnityCloud adds or modifies a VM status in Unity 

.DESCRIPTION  
 
    Set-PSUnityCloud adds or modifies a VM status in Unity's Data Centre view
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the VM

.PARAMETER VMHost
	Name of the VM host

.PARAMETER Cluster
	Name of the cluster

.PARAMETER Site
	Site ID, 1 is left, 2 is right. We're assuming 2 sites, a main site on the left hand-side and a
	disaster recovery site on the right hand-side of the view.

.PARAMETER Status
	Status of the VM, can be a number between 0 and 6.
    the status codes can be used as follows:
        0  Green, the VM is running
        1  Unknown or not yet managed by PSUnity
        2  Warning level
        3  Error level
        4  Critical level
        5  Starting
        6  Stopping

.PARAMETER Description
	Description of the VM. 
	
	
.EXAMPLE
	Set-PSUnityCloud -Session $Session -Site 1 -Name $name -Host $host -Cluster $cluster -Status 0 -Description "VM up and running"
	Set-PSUnityCloud -Session $Session -Site 2 -Name $name -Host $host
	 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnityCloud
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $VMHost,
            [string] $Cluster,
			[string] $Site = "1",
            [string] $Status = "0",
            [string] $Description = ""
		)
	
	process
	{
		$command = "CLOUD_1.0;$Name;$VMHost;$Cluster;$Site;$Status;$Description"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Set-PSUnityCloudInfo set information about a site in the Cloud view 

.DESCRIPTION  
 
	Set-PSUnityCloudInfo set information about a site in the Cloud view 
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the site

.PARAMETER Role
	Role of the site, can be used to provide additional info

.PARAMETER Location
	Name of location of the site, maybe the name of the city where the site is located.

.PARAMETER Site
	Site ID, 1 is left, 2 is right. We're assuming 2 sites, a main site on the left hand-side and a
	disaster recovery site on the right hand-side of the view.

.PARAMETER Status
	Status of the site, can be a number between 0 and 4. 

.PARAMETER Description
	Description of the site. 
	
	
.EXAMPLE
	Set-PSUnityCloudInfo -Session $Session -Site 1 -Name $name -Role "Main Data Centre" -Location Paris -Status 0 -Description "No issues found"
	 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Set-PSUnityCloudInfo
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Role,
            [string] $Location,
			[ValidateSet("1","2")][string] $Site = "1",
            [string] $Status = 0,
            [string] $Description = ""
		)
	
	process
	{
		$command = "CLOUDINFO_1.0;$Name;$Role;$Location;$Site;$Status;$Description"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Add-PSUnityEvent adds an event to PSUnity Event scene

.DESCRIPTION  
 
	Add-PSUnityEvent adds an event to PSUnity Event scene 
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Name
	Name of the city where the event occurred

.PARAMETER Status
	Status of the event, can be a number between 0 and 4. 

.PARAMETER Description
	Description of the event. 
	
	
.EXAMPLE
	Add-PSUnityEvent -Session $Session -Name $name -Status 0 -Description "some description"
	 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Add-PSUnityEvent
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Status = "0",
            [string] $Description = ""
		)
	
	process
	{
		$command = "EVENT_1.0;$Name;$Status;$Description"
		$Session.Writer.WriteLine($command)
	}
}

<#  
.SYNOPSIS  
	Add-PSUnityEventOccurrence adds the occurrence of events by server or by account to PSUnity Event scene

.DESCRIPTION  
 
	Add-PSUnityEventOccurrence adds the occurrence of events by server or by account to PSUnity Event scene 

    The occurrence of events helps identify which machines or accounts generate the most events.
        
.PARAMETER Session
	Session to a Unity server

.PARAMETER Server
	Name of the server

.PARAMETER Account
	Name of the account 
	
.PARAMETER NumEvents
	Number of events in string format 
	
.EXAMPLE
	Add-PSUnityEventOccurrence -Session $Session -Server $server -NumEvents "$number"
	Add-PSUnityEventOccurrence -Session $Session -Account $accountname -NumEvents "$number"
	 
.NOTES  
    Filename    : PSUnity.ps1
    Author(s)   : Micky Balladelli
 
.LINK  
    https://balladelli.com
    
#>
function Add-PSUnityEventOccurrence
{
	[CmdletBinding()]
	param(
			[Parameter(Mandatory=$True)][PSCustomObject] $Session,
            [string] $Name,
            [string] $Server = $null,
            [string] $Account = $null,
            [string] $NumEvents
		)
	
	process
	{
        if ($Server)
        {
    		$command = "EVENT_BYSERVER1.0;$Server;$NumEvents"
        }
        else
        {
    		$command = "EVENT_BYACCOUNT1.0;$Account;$NumEvents"
        }
		$Session.Writer.WriteLine($command)
	}
}