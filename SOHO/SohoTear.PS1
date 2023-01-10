# SOHOTEAR enthält die Leistungen und Materialien

# Achtung es wird per iSQL.EXE eingelesen, Pfade sind fix, d.h. es muss C:\temp existieren!
# es wird eine Pseudo-CSV-Datei erzeugt, welche dann in Powershell eingelesen wird

"CONNECT C:\temp\sohotech.fdb;"|Set-Content c:\temp\script.sql
$Felder = @"
TABELLE
BELNR
BELNRERWEITERUNG
BEZEICHNUNG
EINZELPREIS
RVOEXTRA
BELNRAUSDRUCK
ABWABTEILUNG
MATERIALART
HERSTELLER
BESTANDTEIL
SONSTIGES
ZUSCHLKUND1
ZUSCHLKUND2
ZUSCHLKUND3
ZUSCHLKUND4
KSKPREIS
"@ -split "`n"
$CSVBegin = @"
'"' ||
"@
$CSVSeparator = @"
|| '";"' ||
"@
$CSVEnd = @"
|| '"'
"@
$CSVValBegin = @"
|| '";' ||
"@
$CSVValEnd = @"
|| ';"' ||
"@
$output = $Felder|%{$CSVBegin}{"$_ $($CSVSeparator)"}{$CSVEnd}
# Ende muss aufgefangen werden
$output[-2] = $output[-2].replace($CSVSeparator, '')
# Für numerische Felder
# 5 ist Einzelpreis
$output[4] = $output[4].Replace($CSVSeparator,$CSVValBegin)
$output[5] = $output[5].Replace($CSVSeparator,$CSVValEnd)
# dann noch . durch , ersetzen
# $output[5] = $output[5].Replace($Felder[4], "replace($($Felder[4]),'.',',')")
Remove-Item C:\temp\BEB-SOHOTEAR.txt
Remove-Item C:\temp\BEL2-SOHOTEAR.txt
Remove-Item C:\temp\Material-SOHOTEAR.txt
Remove-Item C:\temp\BEBZ-SOHOTEAR.txt
$PreisExport=@"
Output C:\temp\BEB-SOHOTEAR.txt;
Select $Output FROM SOHOTEAR WHERE Tabelle = 0 ORDER BY BELNR;
Output C:\temp\BEL2-SOHOTEAR.txt;
Select $Output FROM SOHOTEAR WHERE Tabelle = 1 ORDER BY BELNR;
Output C:\temp\Material-SOHOTEAR.txt;
Select $Output FROM SOHOTEAR WHERE Tabelle = 2 ORDER BY BELNR;
Output C:\temp\BEBZ-SOHOTEAR.txt;
Select $Output FROM SOHOTEAR WHERE Tabelle = 3 ORDER BY BELNR;
Output;
"@
$PreisExport|Add-Content C:\temp\script.sql
.\isql.exe -i C:\temp\script.sql -q -user sysdba -p easy1 -pag 0

$Liste=Get-content c:\temp\BEl2-SOHOTEAR.txt|Select -Skip 3  # die Überschriftszeilen überspringen
$Bel2 = $Liste|ConvertFrom-Csv -Header $Felder -Delimiter ';'|select @{N='BelbebNr';E={"$($_.BelNr)$($_.BelNrErweiterung)00"}},@{N='BEBArt';E={'BEL2'}},@{N='Bezeichnung';E={$_.Bezeichnung}},@{N='Einzelpreis';E={[double]$_.Einzelpreis}},* -ExcludeProperty Tabelle,einzelpreis,belNr,belnrerweiterung,Bezeichnung

$Liste=Get-content c:\temp\BEB-SOHOTEAR.txt|Select -Skip 3  # die Überschriftszeilen überspringen
$BeB = $Liste|ConvertFrom-Csv -Header $Felder -Delimiter ';'|select @{N='BelbebNr';E={"$($_.BelNr)$($_.BelNrErweiterung)00"}},@{N='BEBArt';E={'BEB'}},@{N='Bezeichnung';E={$_.Bezeichnung}},@{N='Einzelpreis';E={[double]$_.Einzelpreis}},* -ExcludeProperty Tabelle,einzelpreis,belNr,belnrerweiterung,Bezeichnung

$Liste=Get-content c:\temp\Material-SOHOTEAR.txt|Select -Skip 3  # die Überschriftszeilen überspringen
$Material = $Liste|ConvertFrom-Csv -Header $Felder -Delimiter ';'|select @{N='BelbebNr';E={"$($_.BelNr)$($_.BelNrErweiterung)"}},@{N='BEBArt';E={''}},@{N='Bezeichnung';E={$_.Bezeichnung}},@{N='Einzelpreis';E={[double]$_.Einzelpreis}},* -ExcludeProperty Tabelle,einzelpreis,belNr,belnrerweiterung,Bezeichnung

$Liste=Get-content c:\temp\BEBZ-SOHOTEAR.txt|Select -Skip 3  # die Überschriftszeilen überspringen
$BEBZ = $Liste|ConvertFrom-Csv -Header $Felder -Delimiter ';'|select @{N='BelbebNr';E={"$($_.BelNr)$($_.BelNrErweiterung)"}},@{N='BEBArt';E={'BEBZ'}},@{N='Bezeichnung';E={$_.Bezeichnung}},@{N='Einzelpreis';E={[double]$_.Einzelpreis}},* -ExcludeProperty Tabelle,einzelpreis,belNr,belnrerweiterung,Bezeichnung

$Encoding=@{Encoding="OEM"}
$artFelder = @(
  @{Name="BelBebNr";Expression={$_.BelBebNr.Trim()}},
  @{Name="ArtArt";Expression={'L'}},
  "Bezeichnung",
  "BebArt",
  "Einzelpreis",
  @{Name="MwSt";Expression={"1"}},
  "Abteilung",
  @{Name="Techniker1";Expression={""}}
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
  @{Name="MaxMenge";Expression={28}}
)
	
$bebz | select -Property $ArtFelder| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path c:\temp\BEBZ-Artikel.CSV -Force @Encoding -Verbose
$beb | select -Property $ArtFelder| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path c:\temp\BEB-Artikel.CSV -Force @Encoding -Verbose

# jetzt könnnen BEBZ-Artikel.CSV und BEB-Artikel.CSV per DlpImport.exe in Artikel.DBF eingelesen werden.

