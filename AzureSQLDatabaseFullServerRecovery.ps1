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

Write-Host "Getting recoverable databases from $SourceServerName"

#Get the list of recoverable databases on the source server
Get-AzureSqlRecoverableDatabase -Server $SourceServerName | %{
                $sourceDatabaseName = $_.Name

		#Create a new database name based on the last available backup for the database
                $targetDatabaseName = "$sourceDatabaseName-$($_.LastAvailableBackupDate.ToString('O'))"
                
		Write-Host "Recovering $sourceDatabaseName as $targetDatabaseName"
		#Start the recovery of the specified database
                Start-AzureSqlDatabaseRecovery -SourceServerName $SourceServerName -SourceDatabaseName $sourceDatabaseName -TargetServerName $TargetServerName -TargetDatabaseName $targetDatabaseName
}
