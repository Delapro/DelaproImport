# adressen enthält Adressen von Kunden oder Lieferanten, siehe auch Tabelle mitarbeiter

$Query = @"
SELECT adr_kunden.mwst_nr1, adr_kunden.ust_id_nr, adr_kunden.preis_schl_k, adr_kunden.preis_schl_p,
       adr_kunden.tage_skonto, adr_kunden.tage_netto, adr_kunden.skonto_p, adr_kunden.skonto_b,
       adr_kunden.skonto_m, adressen.*

FROM            adr_kunden INNER JOIN
                         adressen ON adr_kunden.adr_nr = adressen.adr_nr
"@

$adr = Invoke-SqlCmd -Query $Query -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass

# Dabei stellt die Spalte adr_art die Unterscheidung her, siehe auch Tabelle adr_arten
# 1 = Kunden
# 2 = Lieferanten
# 3 = Sonstige Adressen

$kunJahr="2019"
$kunMonat=" 7"

# Kunden
$k=$adr | Where-Object adr_art -eq 1
# Definition der Kundenfelder Delapro
$Kundefelder = @(
    @{Name="Nummer";Expression={KunNr $_.adr_nr}},
    @{Name="Anrede";Expression={Get-AnredeFromFirma $_.firma}},
    @{Name="Titel";Expression={Get-TitelFromFirma $_.firma}},
    @{Name="Anredefloskel";Expression={[String]::Empty}},
    @{Name="Name";Expression={Get-NameFromFirma $_.firma}},
    @{Name="Vorname";Expression={""}},
    @{Name="Name2";Expression={""}},
    "Strasse",
    "PLZ",
    "Ort",
    "Telefon",
    "Mobilteil",
    "Telefax",
    @{Name="Suchbegriff";Expression={($_.suchname).toUpper()}},
    @{Name="Geburtstag";Expression={""}},
    @{Name="Angelegt";Expression={Get-date $_.aktiv_seit -format "yyyyMMdd"}},  # oder erf_dat
    # @{Name="Bemerkung";Expression={""}},  # ignorieren da Memofeld
    @{Name="Status";Expression={""}},
    @{Name="Markiert";Expression={"F"}},
    @{Name="SkontoLeis";Expression={$_.skonto_b}},  # oder skonto_p  ?
    @{Name="SkontoMat";Expression={$_.skonto_m}},
    @{Name="SkontoBasis";Expression={"B"}},
    @{Name="SkontoTage";Expression={$_.tage_skonto}},
    @{Name="Zieltage";Expression={$_.tage_netto}},
    @{Name="Rechsofort";Expression={""}},
    @{Name="ErwSammelR";Expression={"N"}},
    @{Name="RechnNr";Expression={"1"}},
    @{Name="StornoNr1";Expression={""}},
    @{Name="StornoNr2";Expression={""}},
    @{Name="AbrechJahr";Expression={$kunJahr}},
    @{Name="AbrechMon";Expression={$kunMonat}},
    "Debitor",
    @{Name="PreisArt";Expression={$_.preis_schl_k}},
    @{Name="UeberwDruc";Expression={"N"}},
    @{Name="KulanzNr";Expression={"1"}},
    @{Name="ReklamatNr";Expression={"1"}},
    @{Name="AutoPPass";Expression={"N"}},
    @{Name="LiefertMod";Expression={""}},
    # @{Name="TechMemo";Expression={""}},  # ignorieren da Memofeld
    @{Name="AbrechArt";Expression={""}},   # wird nicht verwendet
    @{Name="AbrechArt2";Expression={""}},  # wird nicht verwendet
    @{Name="PreisArt2";Expression={$_.preis_schl_p}},
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
    "email",
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
    "ust_id_nr",
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
    @{Name="ZAVorgabe";Expression={$_.elrech_vorgabe}},
    @{Name="KXEXNACHDR";Expression={"1"}},  # Export nach R-Druck
    @{Name="KXMethode";Expression={"3"}},   # 3=E-Mail
    # @{Name="KXOptionen";Expression={""}},  # ignorieren da Memofeld, wird von DLPImport nachgeholt!
    @{Name="KXEncrypt";Expression={"1"}},
    @{Name="KXEncPass";Expression={""}},
    @{Name="KXPatVorg";Expression={"2"}},
    @{Name="KXExpLevel";Expression={"2"}},
    # @{Name="KXEMailTem";Expression={""}},   # ignorieren da Memofeld
    @{Name="KXZADruck";Expression={"1"}},
    @{Name="PDFExpMeth";Expression={"3"}}     # 3=E-Mail
)

# Diese Vorgehensweise anstatt direkt Export-CSV aufzurufen sorgt dafür, dass kein Header ausgegeben wird:
$k | Select-Object -Property $KundeFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Kunde.CSV -Force @Encoding -Verbose
	
