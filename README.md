Azure SQL Database: Full Server Recovery
========================================

            
Summary:

The goal of this script is to demonstrate how to use the Azure SQL Database Geo-Restore capability to recover all the databases on one server to a different server. The key scenario for this is the disaster recovery scenario
 where one would want to recover a server suffering an outage to a live server. In the event of a server outage one may want to recover all databases on the server suffering the outage to another live server. In order to do this, a recovery request needs
 to be issued for each database on the server. This can be tedious if the server suffering an outage has several databases. By looping through the recoverable databases, this process can be much more managable.

Prerequisites:

  *  Make sure you have installed Azure PowerShell. Learn how to install Azure PowerShell here:
[http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/](http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/)

  *  Make sure you have connected to your subscription. Azure AD is the recommended authentication method. To authenticate with Azure AD: 

  *  Type the following command in PowerShell: 'Add-AzureAccount'

  *  In the window, type your email and password associated with the account.




PowerShell
Edit|Remove
powershell
<# 
.SYNOPSIS
	Recover all databases on a server to another live server

.DESCRIPTION
	This script walks through the process of recovering all databases on a server to another server. It creates the new databases with the original name of the database and it's last backup time appended to the name.
	This script also returns the requestIDs for the recovery operations so the recoveries can be tracked.

.PARAMETER SourceServerName
	This is the name of the server you are recovering the databases from.

.PARAMETER TargetServerName
	This is the name of the server you are recovering the databases to.

.EXAMPLE
	.\ServerRecovery.PS1 
	-SourceServerName 'ff1psrqz8'
	-TargetServerName 'jjkkrrzz2'

.Notes
	Author: Eli Fisher
	Last Updated:12/31/2014
#>

param([Parameter(Mandatory=$True)]
      [ValidateNotNullOrEmpty()]
      [String]$SourceServerName,
      [Parameter(Mandatory=$True)] 
      [ValidateNotNullOrEmpty()]
      [String]$TargetServerName
      )#end param

Write-Host 'Getting recoverable databases from $SourceServerName'

#Get the list of recoverable databases on the source server
Get-AzureSqlRecoverableDatabase -Server $SourceServerName | %{
        $sourceDatabaseName = $_.Name

		#Create a new database name based on the last available backup for the database
        $targetDatabaseName = '$sourceDatabaseName-$($_.LastAvailableBackupDate.ToString('O'))'
                
		Write-Host 'Recovering $sourceDatabaseName as $targetDatabaseName'
		#Start the recovery of the specified database
        Start-AzureSqlDatabaseRecovery -SourceServerName $SourceServerName -SourceDatabaseName $sourceDatabaseName -TargetServerName $TargetServerName -TargetDatabaseName $targetDatabaseName
}


<#  
.SYNOPSIS 
    Recover all databases on a server to another live server 
 
.DESCRIPTION 
    This script walks through the process of recovering all databases on a server to another server. It creates the new databases with the original name of the database and it's last backup time appended to the name. 
    This script also returns the requestIDs for the recovery operations so the recoveries can be tracked. 
 
.PARAMETER SourceServerName 
    This is the name of the server you are recovering the databases from. 
 
.PARAMETER TargetServerName 
    This is the name of the server you are recovering the databases to. 
 
.EXAMPLE 
    .\ServerRecovery.PS1  
    -SourceServerName 'ff1psrqz8' 
    -TargetServerName 'jjkkrrzz2' 
 
.Notes 
    Author: Eli Fisher 
    Last Updated:12/31/2014 
#> 
 
param([Parameter(Mandatory=$True)] 
      [ValidateNotNullOrEmpty()] 
      [String]$SourceServerName, 
      [Parameter(Mandatory=$True)]  
      [ValidateNotNullOrEmpty()] 
      [String]$TargetServerName 
      )#end param 
 
Write-Host 'Getting recoverable databases from $SourceServerName' 
 
#Get the list of recoverable databases on the source server 
Get-AzureSqlRecoverableDatabase -Server $SourceServerName | %{ 
        $sourceDatabaseName = $_.Name 
 
        #Create a new database name based on the last available backup for the database 
        $targetDatabaseName = '$sourceDatabaseName-$($_.LastAvailableBackupDate.ToString('O'))' 
                 
        Write-Host 'Recovering $sourceDatabaseName as $targetDatabaseName' 
        #Start the recovery of the specified database 
        Start-AzureSqlDatabaseRecovery -SourceServerName $SourceServerName -SourceDatabaseName $sourceDatabaseName -TargetServerName $TargetServerName -TargetDatabaseName $targetDatabaseName 
} 





The goal of this script is to demonstrate how to use the Azure SQL Database Geo-Restore capability to recover all the databases on one server to a different server. The key scenario for this is the disaster recovery scenario where one would want to recover
 a server suffering an outage to a live server. In the event of a server outage one may want to recover all databases quickly to a new server. In order to do this, a recovery request needs to be issued for each database on the server.

        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
