# Sammelrech.PS1 importiert Monatsaufstellungen

$Rech = Invoke-SqlCmd -Query "SELECT * FROM sammelrech" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$RechFelder = @(
    @{Name="Nummer";Expression={"$(KunNr $_.knd_nr)$(Monat $_.monat)$($_.jahr.ToString().SubString(2, 2))" }},
    @{Name="AuftragNr";Expression={""}},
    @{Name="Datum";Expression={Get-date $_.druck_dat -format "yyyyMMdd"}},
    @{Name="Ziel";Expression={""}},
    @{Name="KunNummer";Expression={KunNr $_.knd_nr}},
    @{Name="Zahlstatus";Expression={"B"}},
    @{Name="BezDat1";Expression={""}},
    @{Name="BezDat2";Expression={""}},
    @{Name="BezDat3";Expression={""}},
    @{Name="BezDat4";Expression={""}},
    @{Name="BezWie1";Expression={""}},
    @{Name="BezWie2";Expression={""}},
    @{Name="BezWie3";Expression={""}},
    @{Name="BezWie4";Expression={""}},
    @{Name="BezWer1";Expression={""}},
    @{Name="BezWer2";Expression={""}},
    @{Name="BezWer3";Expression={""}},
    @{Name="BezWer4";Expression={""}},
    @{Name="BezDM1";Expression={""}},
    @{Name="BezDM2";Expression={""}},
    @{Name="BezDM3";Expression={""}},
    @{Name="BezDM4";Expression={""}},
    @{Name="BezGesam";Expression={""}},
    @{Name="Status";Expression={""}},
    @{Name="Ziel1";Expression={""}},
    @{Name="Ziel2";Expression={""}},
    @{Name="Ziel3";Expression={""}},
    @{Name="Ziel4";Expression={""}},
    @{Name="SummeLeis";Expression={$_.sum_leist}},
    @{Name="SummeEdel";Expression={""}},
    @{Name="SummeZaeh";Expression={""}},
    @{Name="SummeFert";Expression={""}},
    @{Name="SummeGesa";Expression={$_.sum_brutto}},
    @{Name="SMwStLeis";Expression={""}},
    @{Name="SMwStEdel";Expression={""}},
    @{Name="SMwStZaeh";Expression={""}},
    @{Name="SMwStFert";Expression={""}},
    @{Name="SMwStGesa";Expression={""}},
    @{Name="MwSt";Expression={""}},
    @{Name="SkontoZiel";Expression={""}},
    @{Name="Skonto";Expression={""}},
    @{Name="SkontoSumm";Expression={""}},
    @{Name="Export";Expression={""}},
    @{Name="RechnNr";Expression={$_.srech_nr}},   # wird zu Referenzzwecken übernommen
    @{Name="Markiert";Expression={""}},
    @{Name="LNR";Expression={"1"}},
    @{Name="Waehrung";Expression={""}}
)

$rech | Select-Object -Property $RechFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Rechnung.CSV -Force @Encoding -Verbose


# um die Verknüpfung zwischen Aufträgen und Monatsaufstellungen zu bekommen:

$Query = @"
SELECT        sammelrech.srech_nr, sammelrech.knd_nr, sammelrech.druck_dat, sammelrech.monat, sammelrech.jahr, aufkopf.auf_nr
FROM            sammelrech INNER JOIN
                         aufkopf ON sammelrech.srech_nr = aufkopf.srech_nr
"@

$RechMon = Invoke-SqlCmd -Query $Query -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

# mit den Daten aus AufKopf kann man auch die Datei RechAuft.DBF befüllen!
$RechAuftFelder = (
    @{Name="RechnNr";Expression={"$(KunNr $_.knd_nr)$(Monat $_.monat)$($_.jahr.ToString().SubString(2, 2))"}}, 
    @{Name="AuftragNr";Expression={"$(AuftrNr  $_.auf_nr)0"}},  # die hintere 0 steht für AuftrTeil
    @{Name="RechTeil";Expression={[String]::Empty}},
    @{Name="LNr";Expression={"1"}}
)

$RechMon  | Select-Object -Property $RechAuftFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\RechAuft.CSV -Force @Encoding -Verbose

# an dieser Stelle kann man andocken und eine Konvertierung der fortlaufenden Rechnungsnummern in die beim Delapro
# übliche Notation zu überführen. Man muss einfach in RechAuft ein weiteres Feld hinzufügen, wo die Delapronummer
# abgelegt wird. Man kann nun alle zugehörigen Aufträge anfahren und die delaprospezifische Rechnungsnummer eintragen.
# Die delaprospezifische Rechnungsnummer kann aus der RechnNr der Monatsaufstellung und einer im Monat laufend
# vergebenen Nummer erzeugt werden. Aufträge welche den Rechnungs- oder Gutschriftstatus haben, welche nicht in 
# RechAuft vorhanden, also nicht in einer Monatsaufstellung enthalten sind, bekommen beim passenden Monat weitere
# fortlaufende Rechnungsnummern vergeben.