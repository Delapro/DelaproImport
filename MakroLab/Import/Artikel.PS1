# ARTIKEL enthält die Leistungen
	$art = Invoke-SqlCmd -Query "SELECT * FROM Artikel" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
	$artFelder = @(
		@{Name="BelBebNr";Expression={(BelBebNr $_.Nummer).SubString(0,6)}},
		@{Name="ArtArt";Expression={ArtikelGruppe  $_.Nummer $_.Liste $_.Kenner $_.Abteilung }},
		"Bezeichnung",
		@{Name="BebArt";Expression={(BelBebNr $_.Nummer).SubString(6,4) }},
		"Preis0",
		@{Name="MwSt";Expression={"1"}},
		"Abteilung",
		@{Name="Techniker1";Expression={
		TechNr $_.TechVorgabe}},   # TODO: Technikersplitting beachten!
		@{Name="TechProz1";Expression={"100"}},
		@{Name="Techniker2";Expression={""}},
		@{Name="TechProz2";Expression={""}},
		@{Name="Techniker3";Expression={""}},
		@{Name="TechProz3";Expression={""}},
		@{Name="Techniker4";Expression={""}},
		@{Name="TechProz4";Expression={""}},
		@{Name="Techniker5";Expression={""}},
		@{Name="TechProz5";Expression={""}},
		"Preis1",
		"Preis2",
		"Preis3",
		"Preis4",
		"Preis5",
		"Preis6",
		"Preis7",
		"Preis8",
		"Preis9",
		@{Name="KunNummer";Expression={""}},
		@{Name="Bestand";Expression={""}},
		@{Name="AnfangsBes";Expression={""}},
		@{Name="MatArt";Expression={""}},
		"Zeitwert",
		@{Name="EKPreis";Expression={""}},
		@{Name="Markiert";Expression={""}},
		"MindestBestand",
		# @{Name="BelText";Expression={""}},  # MEMO-Feld ignorieren
		@{Name="Preisliste";Expression={"J"}},
		@{Name="Prothetik";Expression={""}},
		@{Name="Datum1";Expression={""}},
		@{Name="Datum2";Expression={""}},
		@{Name="Datum3";Expression={""}},
		@{Name="Datum4";Expression={""}},
		@{Name="Datum5";Expression={""}},
		@{Name="RuestZeit";Expression={""}},
		@{Name="Qualifakt";Expression={""}},
		@{Name="RisikoFakt";Expression={""}},
		@{Name="Gewinn";Expression={""}},
		@{Name="Planzeitwe";Expression={""}},
		"MaxMenge"
		
	)
	
	$art | select -Property $ArtFelder| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Artikel.CSV -Force @Encoding -Verbose
	
If ($Modus -eq [MLVariante]::Paradox) {
    ren $expPath\Artikel.CSV $expPath\Artikel.TXT
    Invoke-Umlaute -CsvFile $expPath\Artikel.TXT -DestFile $expPath\Artikel.CSV
}

#	Möglich weitere Werte: TechVorgabe, TechSplit
#
#	Die Zuordnung der Materialien zur Artikelart läuft über mehrere Felder.
#	Material Allgemein:  Liste= 0 AND Kenner= 1
#	Edelmetall: Liste= 0 AND Kenner= 1 AND Abteilung= 0
#	Zähne: Liste= 0 AND Kenner= 1 AND Abteilung= 1
#	Sonstiges Material: Liste= 0 AND Kenner= 1 AND Abteilung= 2
#	Texte und Sonderartikel: Liste= 0 AND Kenner >= 3
#	Technikersplitting: Liste = 0 AND Kenner = 2
#	
#	Liste ist dieses Feld bei der Artikelsuche:
	
							
	
#	Aber die Namen für obige Listen sind nicht in der SQL-Datenbank zu finden sondern in der Dental.INI unter der Sektion [ArtikelListen] von Liste0 bis Liste29
	
	
#	Die Suche nach den Leistungsverwaltungen bringt den die Query Liste=0 AND (Kenner=0 AND LEN (Nummer) = 5 AND Nummer like "B%"   B
	
#	N=BELII-2014
#	B=BELII
#	_.=BEB Zahntechnik    und LEN (Nummer) == 9
#	7=BEB97
#	6=PLZ97
#	9=BEB90
	
	

	
	
#	Es gibt die Spalte MNGruppe, welche auch im Programm MN-Gruppe heißt. Dies ist im Prinzip eine Zuordnung zu Delapro Protethikpasszuordnung beim Artikel. Dabei sind diese Werte momentan vorhanden:
	
#	MNGruppe, die aktuell verwendet werden:
#	--------
#	, 1, 2, 3, 4, 5, 6, 7, 8, 9, 12
#	
#	siehe auch MNGruppe.


