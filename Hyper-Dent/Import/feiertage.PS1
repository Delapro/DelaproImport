# Feiertage.PS1 übernimmt die Feiertage

$feiertage = Invoke-SqlCmd -Query "SELECT * FROM feiertage" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
$feiertagFelder = @(
    @{Name="Datum";Expression={Get-date $_.datum -format "yyyyMMdd"}},
    @{Name="Text";Expression={$_.bez }}
)

$feiertage | Select-Object -Property $feiertagFelder| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Feiertag.CSV -Force @Encoding -Verbose

