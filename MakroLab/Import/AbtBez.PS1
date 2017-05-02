# AbtBez.PS1 importiert Abteilungsbezeichnungen und Einstellungen

$abt = Invoke-SqlCmd -Query "SELECT * FROM AbtBez" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$AbtFelder = @("Nummer",@{Name="Name";Expression={$_.Bezeichnung}})

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$abt | select -Property $AbtFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Abteilun.CSV -Force @Encoding -Verbose

If ($Modus -eq [MLVariante]::Paradox) {
    ren $expPath\Abteilun.CSV $expPath\Abteilun.TXT
    Invoke-Umlaute -CsvFile $expPath\Abteilun.TXT -DestFile $expPath\Abteilun.CSV
}
