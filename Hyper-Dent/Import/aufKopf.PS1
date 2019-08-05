# aufkopf enthält Aufträge

# ermittelt alle
# $auftrag = Invoke-SqlCmd -Query "SELECT BELEG.*, BELEGZUS.AbrechID FROM BELEG LEFT JOIN BELEGZUS ON Beleg.Referenz = BelegZus.Belegreferenz " -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
$auftrag = Invoke-SqlCmd -Query "SELECT * FROM aufkopf" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

$AuftragFelder = @(
    @{Name="Nummer";Expression={AuftrNr  $_.auf_nr}},
    @{Name="Datum";Expression={If ($_.rech_dat.length -eq 0) {Get-date $_.auf_dat -format "yyyyMMdd"} else {Get-date $_.rech_dat -format "yyyyMMdd"}}},
    @{Name="Status";Expression={"$(AuftragArt $_.status)$(If ($_.srech_dat.length -gt 0) {"M"})"}},
    @{Name="LieferTerm";Expression={If ($_.lief_dat.length -eq 0) {""} else {Get-date $_.lief_dat -format "yyyyMMdd"}}},
    @{Name="Patient";Expression={Patientenname $_.pat_vorname $_.pat_nachname}},
    @{Name="KunNummer";Expression={KunNr $_.knd_nr}},
    @{Name="PreisArt";Expression={"1"}},
    @{Name="AbrechArt";Expression={"L"}},
    @{Name="ArtikulaNr";Expression={""}},
    "Leistung",
    "Mat0",    # SummeEdel
    "Mat1",    # SummeZaeh
    "Mat2",    # SummeFert
    @{Name="SummeGesa";Expression={$_.Leistung + $_.Mat0 + $_.Mat1 + $_.Mat2}},
    @{Name="SMwStLeis";Expression={""}},
    @{Name="SMwStEdel";Expression={""}},
    @{Name="SMwStZaeh";Expression={""}},
    @{Name="SMwStFert";Expression={""}},
    @{Name="SMwStGesa";Expression={$_.MwStDM}},
    @{Name="MwStLeist";Expression={""}},
    @{Name="MwStEdelm";Expression={""}},
    @{Name="MwStZaehn";Expression={""}},
    @{Name="MwStFerti";Expression={""}},
    @{Name="KasseLeist";Expression={""}},
    @{Name="KasseEdelm";Expression={""}},
    @{Name="KasseZaehn";Expression={""}},
    @{Name="KasseFerti";Expression={""}},
    @{Name="RechnNr";Expression={""}},  # druck_rech_nr
    @{Name="Kronenzu";Expression={""}},
    "mwst_pr_l",
    @{Name="Volumen";Expression={If ($_.status -eq 4) {$_.sum_brutto * -1} else {$_.sum_brutto}}},  # 4=Gutschrift
    @{Name="AuftragArt";Expression={AuftragArt $_.status}},
    @{Name="AtiNummer";Expression={""}},
    "Kasse",
    # leider sind schon Zahnfarben mit Newline davor aufgetaucht, deshalb:
    @{Name="Zahnfarbe";Expression={$_.zahnfarbe.Replace([string][char]13+[char]10, '')}},
    # @{Name="Bemerkung";Expression={""}},  # ignorieren da Memofeld
    @{Name="Gedruckt";Expression={If ($_.rech_dat.length -eq 0) {""} else {Get-date $_.rech_dat -format "yyyyMMdd"}}},   # TODO:
    @{Name="AuftrTeil";Expression={"0"}},
    @{Name="TeileAnz";Expression={""}},
    @{Name="Beleg";Expression={If ($_.druck_rech_nr.length -lt 0) {""} else {If ($_.druck_rech_nr.Length -gt 10) {$_.druck_rech_nr.Substring($_.druck_rech_nr.Length-10)} else {$_.druck_rech_nr} }}},  # damit kann man nach der alten Rechnungsnummer suchen, es werden die rechten 10 Zeichen übernommen
    @{Name="Geaendert";Expression={""}},
    @{Name="Erledigt";Expression={"T"}},
    # @{Name="ProthPass";Expression={""}},  # ignorieren da Memofeld
    @{Name="Markiert";Expression={""}},
    # @{Name="Zahnschema";Expression={""}},  # ignorieren da Memofeld
    @{Name="Oberunterk";Expression={""}},   # wird nicht benutzt
    @{Name="AbrechArt2";Expression={"7"}},  # TODO: BEB-Vorgabe beachten
    @{Name="PreisArt2";Expression={"1"}},
    @{Name="AbrechNr";Expression={""}},
    @{Name="LfzGedruck";Expression={""}},
    @{Name="LieferZeit";Expression={""}},
    @{Name="RechDat";Expression={""}},
    @{Name="ProthPNr";Expression={""}},
    @{Name="Angelegt";Expression={Get-date $_.erf_dat -format "yyyyMMdd"}},   # 
    @{Name="Herkunft";Expression={""}},
    @{Name="Schale";Expression={""}},
    @{Name="Techniker";Expression={""}},
    @{Name="LieferTer2";Expression={""}},
    @{Name="LieferTer3";Expression={""}},
    @{Name="LieferZei2";Expression={""}},
    @{Name="LieferZei3";Expression={""}},
    @{Name="QDAuftrag";Expression={""}},
    @{Name="LieferTer4";Expression={""}},
    @{Name="LieferTer5";Expression={""}},
    @{Name="LieferZei4";Expression={""}},
    @{Name="LieferZei5";Expression={""}},
    # leider sind wie bei Zahnfarben schon Newline aufgetaucht, deshalb:
    @{Name="ArbeitsArt";Expression={$_.text_extern.Replace([string][char]13+[char]10, '')}},
    @{Name="Waehrung";Expression={"1"}},
    @{Name="KWaehrung";Expression={"1"}},
    @{Name="SummeLeis2";Expression={""}},
    @{Name="SummeEdel2";Expression={""}},
    @{Name="SummeZaeh2";Expression={""}},
    @{Name="SummeFert2";Expression={""}},
    @{Name="SummeGesa2";Expression={""}},
    @{Name="SMwStLeis2";Expression={""}},
    @{Name="SMwStEdel2";Expression={""}},
    @{Name="SMwStZaeh2";Expression={""}},
    @{Name="SMwStFert2";Expression={""}},
    @{Name="SMwStGesa2";Expression={""}},
    @{Name="VolumenNet";Expression={""}},
    @{Name="FertStatus";Expression={""}},
    @{Name="Bilder";Expression={""}},
    @{Name="BildVorgab";Expression={""}},
    @{Name="AutoGUmsID";Expression={""}},
    @{Name="AutoSort";Expression={""}},
    @{Name="BezStatus";Expression={""}},
    @{Name="Ziel";Expression={""}},
    @{Name="ZahlBed";Expression={""}},
    @{Name="Herstland";Expression={""}},
    # @{Name="Historie";Expression={""}},  # ignorieren da Memofeld
    @{Name="Garantie";Expression={""}},
    @{Name="ZAuftragNr";Expression={If($_.elauf_nr.Length -gt 12) {$_.elauf_nr} else {""} }},    # ZAuftragNr
    @{Name="KXStatus";Expression={""}},
    @{Name="KXDatum";Expression={""}},
    @{Name="KXNEMPreis";Expression={""}},
    @{Name="KXNEM";Expression={""}},
    @{Name="Status2";Expression={"$(AuftragArt $_.status)$(If ($_.srech_dat.length -gt 0) {"M"})"}}
)

If ($debug) {
    $auftrag = $auftrag | Select-Object -Last 20
}

$auftrag  | Select-Object -Property $AuftragFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Auftrag.CSV -Force @Encoding -Verbose

