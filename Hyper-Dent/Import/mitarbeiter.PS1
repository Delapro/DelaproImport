# Mitarbeiter enthält alle Techniker bzw. sonstige Mitarbeiter

$t = Invoke-SqlCmd -Query "SELECT * FROM mitarbeiter" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

# Dabei stellt die Spalte Mit_Typ die Unterscheidung her.
# 1 = Techniker
# 0 = sonstiger Mitarbeiter

# Definition der Technikerfelder Delapro
$Technikerfelder = @(
    @{Name="Nummer";Expression={TechNr $_.mit_nr}},
    @{Name="Anrede";Expression={""}},
    @{Name="Anredefloskel";Expression={""}},
    @{Name="Titel";Expression={""}},
    @{Name="Name";Expression={$_.Nachname}},
    "Vorname",
    # @{Name="Name2";Expression={""}},
    @{Name="Strasse";Expression={""}},
    @{Name="PLZ";Expression={""}},
    @{Name="Ort";Expression={""}},
    "Telefon",
    "Mobiltel",
    @{Name="Eintritt";Expression={Get-date $_.Eintritt -format "yyyyMMdd"}},
    #  @{Name="Suchbegriff";Expression={$_.Name.toUpper()}},
    @{Name="GebDat";Expression={If ($_.Geburtstag.length -eq 0) {""} else {Get-date $_.Geburtstag -format "yyyyMMdd"}}},
    @{Name="Abteilung";Expression={""}}
    # weitere Felder, aber nicht relevant...
    # @{Name="Bemerkung";Expression={""}},  # ignorieren da Memofeld
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$t | Select-Object -Property $TechnikerFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Technike.CSV -Force @Encoding -Verbose

    # $t | select Nummer, Anrede_1, Anrede_2, Vorname, Name, Strasse, PLZ, Ort,  Mail, Mobil, TelFirma, TelPrivat, IBAN_1, IBAN_2, Konto_1, Konto_2, Land, Geburtstag, FaxFirma, AbsenderZeile, BLZ_2, BLZ_1, BIC_2, BIC_1, Bank_2, Bank_1, BankNr2, BankNr | | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Techniker.CSV -Force @Encoding -Verbose


