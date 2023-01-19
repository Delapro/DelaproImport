# Eine Jumbodatei hat die Endung .JMB die Dateien liegen als normale Dateien im Dateisystem vor und können auch über
# Dateiverzeichnisse organisiert werden.
#
# Ein Jumbosatz ist immer 347(0x15b) Bytes lang.
#
# Die erste Zahl in einem Satz ist immer die Zeilennummer dann folgt ein 0x00 danach die Länge der Bel-Nr in Bytes, aber maximal 0x05
# Danach kommt die Länge des nachfolgenden Strings in Bytes. Die weiteren Daten sind noch nicht analysiert, vor allem hinten raus
# kommen wahrscheinlich noch relevante Daten.

# Offensichtlich wurde die Dateistruktur, nachdem die BEB-Zahntechnik eingeführt wurde beibehalten, allerdings gab es dadurch
# Probleme die sechsstelligen Nummern abzubilden. Aus diesem Grund wurde scheinbar mittels @-Zeichen eine spezielle Erweiterung
# eingeführt um fehlende Bel-Nr. zu ergänzen was dann bei BEBZ- und Material-Nummern benutzt wurde.

# Schneller Überblick in welcher Datei wieviel Jumbopositionen hinterlegt sind:
dir *.jmb|select @{N='JumboPos';E={$_.Length/0x15b}}, name, lastwritetime

# verlangt einen Dateinamen einer .JMB-Datei und gibt die enthaltenen Jumbopositionen zurück

# mit der Funktion kann man ermitteln welche Positionen vor allem in Jumbos vorkommen
dir -File |Get-JumboPos|group belnr|sort count

# Wahrscheinlich gibt es eine spezielle Logik, dass wenn bei der Feldlänge der BelNr 0 steht, dass es 
# sich dann um eine gelöschte Position handelt?

Function Get-JumboPos {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    $Path
  )

  Begin {
    Function Get-Record {
      Param(
        $record
      )

      $Zeile = [int]$record[0]
      $length = $record[2]
      $BelNr = $record[3..(3+$length-1)] -join ''
      $BelExt = ''
      $length = $record[8]
      $Text = $record[9..(9+$length-1)] -join ''
      $ExtText = ''
      $ExtPos = $Text.IndexOf('@')
      If ($ExtPos -ge 0) {
        $ExtText = $Text.SubString($ExtPos)
        $Text = $Text.SubString(0, $ExtPos)
        If ($ExtText.SubString(0,3) -eq '@0@') {
          $BelExt = $ExtText.SubString($ExtText.IndexOfAny('@', 2)+1, $ExtText.IndexOfAny('@',3) -$ExtText.IndexOfAny('@',2)-1)
        }
      }
      [PSCustomObject]@{Zeile=$Zeile;BelNr=$BelNr+$BelExt;Text=$Text;ExtText=$ExtText}
    }
  }
  
  Process {
    $recordSize = 0x15b
    $pos = [int]0
    $j = Get-Content $Path -Raw
    If ($j) {
      while ($pos -lt $j.length/$recordSize) {
        Get-Record $j[($pos*$recordSize)..(($pos+1)*$recordSize-1)]
        $pos += 1
      }
    }
  }
}

# PosNr also Zeilenr rechtsbündig, dreistellig formatieren
Function PosNrRight {$p=$args[0]; $p.ToString().Trim().PadLeft(7).SubString(4,3) }

# versucht die BelBebNr in eine delaprokonforme Richtung zu bringen
Function FormBelBebNr {Param($BelBebNr)
     If ($BelBebNr.IndexOf('.') -gt -1) {
          # BEL2 oder BEBZ Position
          If ($BelBebNr.IndexOf('.') -eq 3) {
               # BEL2
               $BelBebNr = $BelBebNr.Replace('.','').PadRight(6,'0')+'BEL2'
          } else {
               # BEBZ
               $BelBebNr = $BelBebNr.Replace('.','').PadRight(6,'0')+'BEBZ'
          }
          
     } else {
          # Material oder PLZ-Position
          If (($BelBebNr.Length -eq 6) -and ($BelBebNr.SubString(0,1) -eq '9')) {
               # Material
               $BelBebNr += '    '
          } else {
               $BelBebNr = $BelBebNr.PadRight(6,'0')+'PLZ '
          }
     }

     $BelBebNr
}

$expPath = 'C:\Temp'
$Encoding=@{Encoding="OEM"}

Remove-Item $expPath\StueckP2.CSV -ea SilentlyContinue
Remove-Item $expPath\StueckL2.CSV -ea SilentlyContinue

# stuevl01 - stuevl99
# Name = "AUTORECORD!!"
# Nummer = interne Jumbonummer
# Bemerkung = Name der Jumboverwaltung
# stuevP01 - wie gewohnt

$JumboFelder = @(
     @{Name="Name";Expression={"J$($global:JNr+1)"}},
     @{Name="Nummer";Expression={$global:JNr++; $global:JNr }},
     @{Name="Bezeichnung";Expression={$_.Name.Replace('.JMB','').Replace('.jmb','')}},
     @{Name="SofortEins";Expression={"J"}},
     @{Name="Markiert";Expression={""}},
     @{Name="AbrechArt";Expression={"L"}},
     @{Name="Zahnschema";Expression={"F"}}
)

$juPosFelder=@(
     @{Name="Nummer";Expression={$global:JNr}},
     @{Name="BelNr";Expression={FormBelBebNr -BelBebNr $_.BelNr}},
     @{Name="Menge";Expression={"0"}},
     @{Name="Text";Expression={$_.Text}},
     @{Name="AuftrTeil";Expression={"1"}},
     @{Name="PreisArt";Expression={"1"}},
     @{Name="Abteilung";Expression={""}},
     @{Name="Techniker1";Expression={""}},
     @{Name="TechProz1";Expression={"100"}},
     @{Name="Techniker2";Expression={""}},
     @{Name="TechProz2";Expression={""}},
     @{Name="Techniker3";Expression={""}},
     @{Name="TechProz3";Expression={""}},
     @{Name="Techniker4";Expression={""}},
     @{Name="TechProz4";Expression={""}},
     @{Name="Techniker5";Expression={""}},
     @{Name="TechProz5";Expression={""}},
     @{Name="Rueckfrage";Expression={""}},
     @{Name="KontaktPkt";Expression={"N"}},
     @{Name="MengenKalk";Expression={""}},
     @{Name="PosNr";Expression={PosNrRight $_.Zeile.ToString()}}
)


#############
# hier muss vorher das Jumbo-Verzeichnis angefahren werden!
#############

## WICHTIG: Es wird nur eine Ebene von Jumbos übernommen, tiefergeschachtelte Jumbos werden ignoriert!

$Verzeichnisse = Dir -Directory
$VerzeichnisNr = 1
foreach ($Verzeichnis in $Verzeichnisse) {

     $global:JNr=1000
     $ExportJumboDatei = "$($expPath)\StueVL$($VerzeichnisNr.ToString().PadLeft(2, '0')).CSV"
     $ExportJumboPosDatei = "$($expPath)\StueVP$($VerzeichnisNr.ToString().PadLeft(2, '0')).CSV"

     $Jumbodateien = Dir -Path $Verzeichnis.Fullname -file -Filter '*.JMB'
     "$($Verzeichnis): $($Jumbodateien.Length)"

     # Name = "AUTORECORD!!"
     # Nummer = interne Jumbonummer
     # Bemerkung = Name der Jumboverwaltung
     [PSCustomObject]@{Name='AUTORECORD!!';Nummer=$Jumbodateien.Length+1;Bemerkung="$($Verzeichnis)  ($VerzeichnisNr)";SofortEins='J';Markiert='';AbrechArt='L';Zahnschema='F'} | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1| Add-Content -Path $ExportJumboDatei @Encoding -Verbose

     foreach ($Jumbodatei in $Jumbodateien) {
          $Jumbodatei | Select -Property $JumboFelder | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1| Add-Content -Path $ExportJumboDatei @Encoding -Verbose

          $JuPos = Get-JumboPos -Path $Jumbodatei.Fullname

          $JuPos | Select -Property $JuPosFelder | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1| Add-Content -Path $ExportJumboPosDatei @Encoding
     }

     $VerzeichnisNr++
}

Function Import-StueckLi {
     Param(
          [String]$Nummer
     )

     $Nummer = $Nummer.PadLeft(2, '0')
     copy-Item .\StueckLi.dbf "c:\temp\StueVL$($Nummer).dbf"
     copy-Item .\StueckPo.dbf "c:\temp\StueVP$($Nummer).dbf"
     .\DLPImport.exe  ".\StueVL$($Nummer).csv" /AUTOIMPORT /ZAP
     .\DLPImport.exe  ".\StueVP$($Nummer).csv" /AUTOIMPORT /ZAP
}

#############
## CSV-Dateien übernehmen
#############

# DLPImport.EXE und StueckLi.DBF sowie StueckPo.DBF müssen als Vorlage im aktuellen Verzeichnis vorhanden sein
Import-StueckLi -Nummer 1
Import-StueckLi -Nummer 2
Import-StueckLi -Nummer 3
Import-StueckLi -Nummer 4
Import-StueckLi -Nummer 5
Import-StueckLi -Nummer 6
#usw.

