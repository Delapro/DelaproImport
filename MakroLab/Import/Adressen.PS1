# ADRESSEN enthält alle Adressen egal ob Techniker, Kunden, oder Krankenkassen

$adr = Invoke-SqlCmd -Query "SELECT * FROM Adressen" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

# Dabei stellt die Spalte Typ die Unterscheidung her.
# 1 = Kunden
# 2 = Techniker
# 6 = Krankenkasse

# Techniker 
$t=$adr | where typ -eq 2
# Definition der Technikerfelder Delapro
$Technikerfelder = @(
    @{Name="Nummer";Expression={TechNr $_.Nummer}},
        "Anrede_1",
    @{Name="Anredefloskel";Expression={""}},
        "Anrede_2",
    @{Name="Name";Expression={$_.Name}},
    "Vorname",
    # @{Name="Name2";Expression={""}},
    "Strasse",
    "PLZ",
    "Ort",
    "TelPrivat",
    "TelFirma",
    @{Name="Eintritt";Expression={""}},
    #  @{Name="Suchbegriff";Expression={$_.Name.toUpper()}},
    @{Name="GebDat";Expression={Get-date $_.Geburtstag -format "yyyyMMdd"}},
    @{Name="Abteilung";Expression={""}}
    # weitere Felder, aber nicht relevant...
    # @{Name="Bemerkung";Expression={""}},  # ignorieren da Memofeld
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$t | select -Property $TechnikerFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Technike.CSV -Force @Encoding -Verbose

    # $t | select Nummer, Anrede_1, Anrede_2, Vorname, Name, Strasse, PLZ, Ort,  Mail, Mobil, TelFirma, TelPrivat, IBAN_1, IBAN_2, Konto_1, Konto_2, Land, Geburtstag, FaxFirma, AbsenderZeile, BLZ_2, BLZ_1, BIC_2, BIC_1, Bank_2, Bank_1, BankNr2, BankNr | | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Techniker.CSV -Force @Encoding -Verbose


# Kunden
$k=$adr | where typ -eq 1
# Definition der Kundenfelder Delapro
$Kundefelder = @(
    @{Name="Nummer";Expression={KunNr $_.Nummer}},
        "Anrede_2",
        "Anrede_1",
    @{Name="Anredefloskel";Expression={""}},
    @{Name="Name";Expression={$_.Name}},
    "Vorname",
    @{Name="Name2";Expression={""}},
    "Strasse",
    "PLZ",
    "Ort",
    "TelFirma",
    "TelPrivat",
    "FaxFirma",
    @{Name="Suchbegriff";Expression={$_.Name.toUpper()}},
    @{Name="Geburtstag";Expression={Get-date $_.Geburtstag -format "yyyyMMdd"}},
    @{Name="Angelegt";Expression={""}},
    # @{Name="Bemerkung";Expression={""}},  # ignorieren da Memofeld
    @{Name="Status";Expression={""}},
    @{Name="Markiert";Expression={""}},
    @{Name="SkontoLeis";Expression={""}},
    @{Name="SkontoMat";Expression={""}},
    @{Name="SkontoBasis";Expression={"B"}},
    @{Name="SkontoTage";Expression={""}},
    @{Name="Zieltage";Expression={"30"}},
    @{Name="Rechsofort";Expression={""}},
    @{Name="ErwSammelR";Expression={"N"}},
    @{Name="RechnNr";Expression={"1"}},
    @{Name="StornoNr1";Expression={""}},
    @{Name="StornoNr2";Expression={""}},
    @{Name="AbrechJahr";Expression={$kunJahr}},
    @{Name="AbrechMon";Expression={$kunMonat}},
    "Debitor",
    @{Name="PreisArt";Expression={"1"}},
    @{Name="UeberwDruc";Expression={"N"}},
    @{Name="KulanzNr";Expression={"1"}},
    @{Name="ReklamatNr";Expression={"1"}},
    @{Name="AutoPPass";Expression={"N"}},
    @{Name="LiefertMod";Expression={""}},
    # @{Name="TechMemo";Expression={""}},  # ignorieren da Memofeld
    @{Name="AbrechArt";Expression={""}},   # wird nicht verwendet
    @{Name="AbrechArt2";Expression={""}},  # wird nicht verwendet
    @{Name="PreisArt2";Expression={""}},
    "BLZ_1",
    "Konto_1",
    @{Name="PSKTOLeis";Expression={""}},
    @{Name="PSktoMat";Expression={""}},
    @{Name="PSktoBasis";Expression={""}},
    @{Name="PSKtTage";Expression={""}},
    @{Name="PZieltage";Expression={""}},
    @{Name="Porto";Expression={""}},
    @{Name="PatNaSort";Expression={"N"}},
    @{Name="MonAufKP";Expression={""}},
    @{Name="Waehrung";Expression={"1"}},
    "Mail",
    @{Name="Rabatt1";Expression={""}},
    @{Name="RabattPro1";Expression={""}},
    @{Name="Rabatt2";Expression={""}},
    @{Name="RabattPro2";Expression={""}},
    @{Name="Rabatt3";Expression={""}},
    @{Name="RabattPro3";Expression={""}},
    @{Name="Rabatt4";Expression={""}},
    @{Name="RabattPro4";Expression={""}},
    @{Name="Rabatt5";Expression={""}},
    @{Name="RabattPro5";Expression={""}},
    @{Name="Rabatt6";Expression={""}},
    @{Name="RabattPro6";Expression={""}},
    @{Name="Rabatt7";Expression={""}},
    @{Name="RabattPro7";Expression={""}},
    @{Name="Rabatt8";Expression={""}},
    @{Name="RabattPro8";Expression={""}},
    @{Name="Rabatt9";Expression={""}},
    @{Name="RabattPro9";Expression={""}},
    @{Name="Rabatt10";Expression={""}},
    @{Name="RabattPro10";Expression={""}},
    @{Name="ZertDruck";Expression={"N"}},
    @{Name="MwStSchl";Expression={"-1"}},  # -1 = Laborvorgabe
    @{Name="WerbRechDr";Expression={""}},
    @{Name="WerbRech1";Expression={""}},
    @{Name="WerbRech2";Expression={""}},
    @{Name="WerbRech3";Expression={""}},
    @{Name="WerbPRecDr";Expression={""}},
    @{Name="WerbPRech1";Expression={""}},
    @{Name="WerbPRech2";Expression={""}},
    @{Name="WerbPRech3";Expression={""}},
    @{Name="WerbKostDr";Expression={""}},
    @{Name="WerbKost1";Expression={""}},
    @{Name="WerbKost2";Expression={""}},
    @{Name="WerbKost3";Expression={""}},
    "UmsID",
    @{Name="WerbMonDr";Expression={""}},
    @{Name="WerbMon1";Expression={""}},
    @{Name="WerbMon2";Expression={""}},
    @{Name="WerbMon3";Expression={""}},
    @{Name="DurchRech";Expression={""}},
    @{Name="DurchKost";Expression={""}},
    @{Name="DurchKula";Expression={""}},
    @{Name="DurchRekl";Expression={""}},
    @{Name="DurchStor";Expression={""}},
    @{Name="DurchGuts";Expression={""}},
    @{Name="DurchAlte";Expression={""}},
    @{Name="DurchTech";Expression={""}},
    @{Name="DurchZahl";Expression={""}},
    @{Name="DurchMona";Expression={""}},
    @{Name="DurchProt";Expression={""}},
    @{Name="DurchStGu";Expression={""}},
    @{Name="Zusatz";Expression={""}},
    @{Name="MonNummer";Expression={""}},  # wird nicht verwendet
    @{Name="GPassDruck";Expression={""}},
    @{Name="GPassDrMat";Expression={""}},
    @{Name="KVText";Expression={""}},
    @{Name="KZVABRECHN";Expression={""}},
    @{Name="MONNACHWEI";Expression={""}},
    @{Name="ZAVorgabe";Expression={""}},
    @{Name="KXEXNACHDR";Expression={"1"}},  # Export nach R-Druck
    @{Name="KXMethode";Expression={"3"}},   # 3=E-Mail
    # @{Name="KXOptionen";Expression={""}},  # ignorieren da Memofeld, wird von DLPImport nachgeholt!
    @{Name="KXEncrypt";Expression={"1"}},
    @{Name="KXEncPass";Expression={""}},
    @{Name="KXPatVorg";Expression={"2"}},
    @{Name="KXExpLevel";Expression={"2"}},
    # @{Name="KXEMailTem";Expression={""}},   # ignorieren da Memofeld
    @{Name="KXZADruck";Expression={"1"}}
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$k | select -Property $KundeFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Kunde.CSV -Force @Encoding -Verbose
	
