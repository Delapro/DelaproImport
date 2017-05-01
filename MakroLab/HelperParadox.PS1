# Hier sind Hilfsroutinen zum Lesen von Paradox-Dateien

Function Open-DBConnection {
    [CmdletBinding()]
    Param(
        [String]$Daten
    )

    If (-Not ([System.IntPtr]::Size -eq 4)) {
        Write-Error "Bitte Powershell als 32-Bit Prozess starten!"
    }
    $f=[System.Data.Common.DbProviderFactories]::GetFactory("System.Data.OleDB")
    $con=$f.CreateConnection()
    $con.ConnectionString="Provider=Microsoft.Jet.OLEDB.4.0; Data Source=$Daten; Extended Properties='Paradox 5.x';"
    $con.Open()
    $global:connection = $con
    
}

# Achtung globale Variable $global:connection muss definiert sein!
# ist ein einfache Nachbau von Invoke-SqlCmd aus SQLPS
Function Invoke-SqlCmd {
	[CmdletBinding()]
	Param(
		[string]$Query,
		[string]$Database,
        [string]$ServerInstance,
		[string]$Username,
		[string]$Password
	)
	$com=$global:connection.CreateCommand()
	$com.CommandText=$Query
	$r=$com.ExecuteReader()
	If ($r.hasRows) {
		$dt=[System.Data.DataTable]::new()
		$dt.Load($r)
	}
	$r.Close()
	$dt
		
}

