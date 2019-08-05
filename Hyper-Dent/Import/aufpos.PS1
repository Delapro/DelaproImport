# aufpos enthält die Auftragspositionen

$Query = @"
SELECT      aufkopf.status AS aufkopfstatus, aufpos.*, positionen.bez, positionen.intern_nr, positionen.druck_nr, positionen.verz
FROM        aufkopf INNER JOIN
                aufpos ON aufkopf.auf_nr = aufpos.auf_nr INNER JOIN
                    positionen ON aufpos.pos_nr = positionen.pos_nr
            order by auf_nr, sort_nr
"@

# $userpass = @{
#    Username = $username
#    Password = $pass
#}

$aufpos = Invoke-SqlCmd -Query $Query -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName -Username $user -Password $pass

$auftrPosFelder = @(
    @{Name="AuftragNr";Expression={AuftrNr $_.auf_nr}},
    @{Name="BelBebNr";Expression={"$(BelNr $_.druck_nr)$(BebArt $_.verz)"}},
    "bez",
    @{Name="Menge";Expression={If($_.aufkopfstatus -eq 4) {$_.menge * -1} else {$_.menge}}},  # 4=Gutschrift
    "Preis",
    @{Name="GPreis";Expression={If($_.aufkopfstatus -eq 4) {$_.Gesamt_netto * -1} else {$_.Gesamt_netto}}}, # 4=Gutschrift
    @{Name="MwSt";Expression={[String]::Empty}},
    "Abteilung",
    @{Name="Techniker1";Expression={TechNr $_.tech1}},   # TODO: Technikersplitting beachten!
    @{Name="TechProz1";Expression={"100"}},
    @{Name="Techniker2";Expression={[String]::Empty}},
    @{Name="TechProz2";Expression={[String]::Empty}},
    @{Name="Techniker3";Expression={[String]::Empty}},
    @{Name="TechProz3";Expression={[String]::Empty}},
    @{Name="Techniker4";Expression={[String]::Empty}},
    @{Name="TechProz4";Expression={[String]::Empty}},
    @{Name="Techniker5";Expression={[String]::Empty}},
    @{Name="TechProz5";Expression={[String]::Empty}},
    # alte Fassung: @{Name="ArtArt";Expression={ArtArt $_.Typ}},
    @{Name="ArtArt";Expression={ArtikelGruppe  $_.verz}},
    @{Name="Privat";Expression={[String]::Empty}},
    "Zeitwert",
    @{Name="Termin";Expression={[String]::Empty}},
    @{Name="Maximal";Expression={[String]::Empty}},
    @{Name="Uhrzeit";Expression={[String]::Empty}},
    @{Name="Bemerkung";Expression={[String]::Empty}},
    @{Name="KunTermin";Expression={[String]::Empty}},
    @{Name="KunUhrzeit";Expression={[String]::Empty}},
    @{Name="PreisArt";Expression={"1"}},
    @{Name="AuftrTeil";Expression={"1"}},
    @{Name="Gedruckt";Expression={"T"}},
    @{Name="Zahnschema";Expression={"F"}},
    @{Name="PosNr";Expression={PosNr $_.sort_nr}},
    @{Name="Abteil1";Expression={[String]::Empty}},
    @{Name="Abteil2";Expression={[String]::Empty}},
    @{Name="Abteil3";Expression={[String]::Empty}},
    @{Name="Abteil4";Expression={[String]::Empty}},
    @{Name="Abteil5";Expression={[String]::Empty}},
    @{Name="Rueckfrage";Expression={[String]::Empty}},
    # @{Name="Langtext";Expression={""}},  # Memofeld ignorieren
    "Charge"
)

If ($debug) {
    $aufpos = $aufpos | Select-Object -Last 300
}

$aufpos | Select-Object -Property $auftrPosFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\AuftrPos.CSV -Force @Encoding -Verbose

