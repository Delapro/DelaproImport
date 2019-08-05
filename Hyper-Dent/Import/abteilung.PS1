# Abteilung.PS1 importiert Abteilungsbezeichnungen und Einstellungen

$abt = Invoke-SqlCmd -Query "SELECT * FROM Abteilung" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$AbtFelder = @(
    @{Name="Nummer";Expression={$_.abt_nr}},
    @{Name="Name";Expression={$_.bez}}
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$abt | Select-Object -Property $AbtFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Abteilun.CSV -Force @Encoding -Verbose

