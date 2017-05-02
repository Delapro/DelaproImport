# BELEGZUS enthält weitere Infos zu Aufträgen, z. B. XML-Auftragsnummer
# Enthält über BelegReferenz Relation zu BELEG->Referenz

#	Bei den Belegen gibt es zwei ähnliche Felder, einmal Typ und einmal Belegtyp. Der einzige Unterschied tritt auf, wenn es um Gutschriften geht. Dann ist Typ=0 und Belegtyp=1. Könnte etwas mit der Verbuchung zu tun haben, damit bei dieser Konstellation die Summen negiert werden. Ansonsten gilt
#   obiges von BelegArt.


	# stellt Verbindung zwischen BELEG und BELEGZUS her, ermittelt nur die letzten 100
#	$auftrag = Invoke-SqlCmd -Query "SELECT B.Kunde, B.Typ, B.RG_Nummer, b.Aufnummer, b.Referenz, b.Belegdatum, z.Abrechid FROM BELEG B inner join BELEGZUS z on b.referenz = z.belegreferenz WHERE b.ID > ( select MAX(ID) -100 from Beleg)" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

#	$auftrag = Invoke-SqlCmd -Query "SELECT Beleg.*, BelegZus.Abrechid FROM BELEG inner join BELEGZUS on beleg.referenz = belegzus.belegreferenz WHERE beleg.ID > ( select MAX(ID) -100 from Beleg)" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

	# ermittelt alle
	$auftrag = Invoke-SqlCmd -Query "SELECT BELEG.*, BELEGZUS.AbrechID FROM BELEG LEFT JOIN BELEGZUS ON Beleg.Referenz = BelegZus.Belegreferenz " -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

	$AuftragFelder = @(
		@{Name="Nummer";Expression={AuftrNr  $_.Referenz}},
		@{Name="Datum";Expression={Get-date $_.BelegDatum -format "yyyyMMdd"}},
		@{Name="Status";Expression={AuftragArt $_.BelegTyp}},
		@{Name="LieferTerm";Expression={Get-date $_.LieferDatum -format "yyyyMMdd"}},
		"Patient",
		@{Name="KunNummer";Expression={KunNr $_.Kunde}},
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
		@{Name="RechnNr";Expression={RechNr $_.RG_Nummer (KunNr $_.Kunde)}},
		@{Name="Kronenzu";Expression={""}},
		"MwSt_Satz",
		@{Name="Volumen";Expression={$_.Brutto}},
		@{Name="AuftragArt";Expression={AuftragArt $_.BelegTyp}},
		@{Name="AtiNummer";Expression={""}},
		"Kasse",
		"Zahnfarbe",
		# @{Name="Bemerkung";Expression={""}},  # ignorieren da Memofeld
		@{Name="Gedruckt";Expression={Get-date $_.BelegDatum -format "yyyyMMdd"}},   # TODO:
		@{Name="AuftrTeil";Expression={"0"}},
		@{Name="TeileAnz";Expression={""}},
		@{Name="Beleg";Expression={""}},
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
		@{Name="Angelegt";Expression={Get-date $_.ErstBenutzerDatum -format "yyyyMMdd"}},   # 
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
		"ArbeitsArt",
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
		"AbrechID",    # ZAuftragNr
		@{Name="KXStatus";Expression={""}},
		@{Name="KXDatum";Expression={""}},
		@{Name="KXNEMPreis";Expression={""}},
		@{Name="KXNEM";Expression={""}},
		@{Name="Status2";Expression={AuftragArt $_.BelegTyp}}
	)

	$auftrag  | select -Property $AuftragFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Auftrag.CSV -Force @Encoding -Verbose

If ($Modus -eq [MLVariante]::Paradox) {
    ren $expPath\Auftrag.CSV $expPath\Auftrag.TXT
    Invoke-Umlaute -CsvFile $expPath\Auftrag.TXT -DestFile $expPath\Auftrag.CSV
}
