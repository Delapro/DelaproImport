# Positionen enthält die Leistungs-/Materialverwaltung

$art = Invoke-SqlCmd -Query "SELECT * FROM positionen" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
$artFelder = @(
    @{Name="BelBebNr";Expression={BelNr $_.druck_nr}},
    @{Name="ArtArt";Expression={ArtikelGruppe  $_.verz }},
    "bez",
    @{Name="BebArt";Expression={BebArt $_.verz }},
    "Preis0",
    @{Name="MwSt";Expression={"1"}},
    @{Name="Abteilung";Expression={""}},
    @{Name="Techniker1";Expression={
    TechNr $_.tech1}},   # TODO: Technikersplitting beachten!
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
    "Max_Menge"
    
)

If ($debug) {
    $art = $art | Select-Object -Last 100
}

$art | Select-Object -Property $ArtFelder| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Artikel.CSV -Force @Encoding -Verbose
