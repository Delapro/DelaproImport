# ArbArt.PS1 importiert die Art der Arbeit

$ArbArt = Invoke-SqlCmd -Query "SELECT * FROM ArbArt" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$ArbArt  | select -Property Bezeichnung| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\ArbeitAr.CSV -Force @Encoding -Verbose

