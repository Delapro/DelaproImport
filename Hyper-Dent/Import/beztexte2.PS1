# BezTexte2.PS1 - Sammlung von allen möglichen variablen Texten

# das Feld type definiert:
<#
NichtDefiniert=0
Anrede=1
Anredefloskeln=5
TelefonTyp=6
LeistungsMaterialVerzeichnis=7
MaterialEinheit=9
Innung=11
ArtDerArbeit=13
Zahnfarbe=15
Krankenkasse=18
Textbaustein=27
#>
# das Feld nummer ist dann innerhalb von type eine eindeutige Nummer unter der bez gespeichert ist


$anrede = Invoke-SqlCmd -Query "SELECT * FROM BezTexte2 WHERE type=1" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$AnredeFelder = @(
    # @{Name="Nummer";Expression={$_.nummer}},
    @{Name="Anrede";Expression={$_.bez}}
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$anrede | Select-Object -Property $AnredeFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Anrede.CSV -Force @Encoding -Verbose


$ArtDerArbeit = Invoke-SqlCmd -Query "SELECT * FROM BezTexte2 WHERE type=13" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$ArtDerArbeitFelder = @(
    # @{Name="Nummer";Expression={$_.nummer}},
    @{Name="ArbeitArt";Expression={$_.bez}}
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$ArtDerArbeit | Select-Object -Property $ArtDerArbeitFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\ArbeitArt.CSV -Force @Encoding -Verbose


$Zahnfarbe = Invoke-SqlCmd -Query "SELECT * FROM BezTexte2 WHERE type=15" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$ZahnfarbeFelder = @(
    # @{Name="Nummer";Expression={$_.nummer}},
    @{Name="Zahnfarbe";Expression={$_.bez}}
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$Zahnfarbe | Select-Object -Property $ZahnfarbeFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Zahnfarb.CSV -Force @Encoding -Verbose


