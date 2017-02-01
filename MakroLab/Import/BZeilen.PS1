# BZEILEN enthält die Auftragspositionen
#	Typ ist eine Art von Artikelart, 0=BEL2, 1=Privat, 3=Text, 2=?
	
	$aufpos = Invoke-SqlCmd -Query "SELECT * FROM BZeilen" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
	
	$auftrPosFelder = @(
		@{Name="AuftragNr";Expression={AuftrNr $_.RefNummer}},
		@{Name="BelBebNr";Expression={BelBebNr $_.LNummer}},
		"Bezeichnung",
		"Menge",
		"Preis",
		@{Name="GPreis";Expression={$_.Menge * $_.Preis}},
		@{Name="MwSt";Expression={""}},
		"Abteilung",
		@{Name="Techniker1";Expression={TechNr $_.Tech}},   # TODO: Technikersplitting beachten!
		@{Name="TechProz1";Expression={"100"}},
		@{Name="Techniker2";Expression={""}},
		@{Name="TechProz2";Expression={""}},
		@{Name="Techniker3";Expression={""}},
		@{Name="TechProz3";Expression={""}},
		@{Name="Techniker4";Expression={""}},
		@{Name="TechProz4";Expression={""}},
		@{Name="Techniker5";Expression={""}},
		@{Name="TechProz5";Expression={""}},
		# alte Fassung: @{Name="ArtArt";Expression={ArtArt $_.Typ}},
		@{Name="ArtArt";Expression={ArtikelGruppe  $_.LNummer $_.Liste $_.Typ$_.Abteilung }},
		@{Name="Privat";Expression={""}},
		"Zeitwert",
		@{Name="Termin";Expression={""}},
		@{Name="Maximal";Expression={""}},
		@{Name="Uhrzeit";Expression={""}},
		@{Name="Bemerkung";Expression={""}},
		@{Name="KunTermin";Expression={""}},
		@{Name="KunUhrzeit";Expression={""}},
		@{Name="PreisArt";Expression={"1"}},
		@{Name="AuftrTeil";Expression={"1"}},
		@{Name="Gedruckt";Expression={"T"}},
		@{Name="Zahnschema";Expression={"F"}},
		@{Name="PosNr";Expression={PosNr $_.Zeile}},
		@{Name="Abteil1";Expression={""}},
		@{Name="Abteil2";Expression={""}},
		@{Name="Abteil3";Expression={""}},
		@{Name="Abteil4";Expression={""}},
		@{Name="Abteil5";Expression={""}},
		@{Name="Rueckfrage";Expression={""}},
		# @{Name="Langtext";Expression={""}},  # Memofeld ignorieren
		"Charge"
	)
	
	$aufpos | Select -Property $auftrPosFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\AuftrPos.CSV -Force @Encoding -Verbose
	
