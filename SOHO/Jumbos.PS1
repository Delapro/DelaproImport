# Eine Jumbodatei hat die Endung .JMB die Dateien liegen als normale Dateien im Dateisystem vor und können auch über
# Dateiverzeichnisse organisiert werden.
#
# Ein Jumbosatz ist immer 347(0x15b) Bytes lang.
#
# Die erste Zahl in einem Satz ist immer die Zeilennummer dann folgt ein 0x00 danach die Länge der Bel-Nr in Bytes, aber maximal 0x05
# Danach kommt die Länge des nachfolgenden Strings in Bytes. Die weiteren Daten sind noch nicht analysiert, vor allem hinten raus
# kommen wahrscheinlich noch relevante Daten.

# Schneller Überblick in welcher Datei wieviel Jumbopositionen hinterlegt sind:
dir *.jmb|select @{N='JumboPos';E={$_.Length/0x15b}}, name, lastwritetime

# verlangt einen Dateinamen einer .JMB-Datei und gibt die enthaltenen Jumbopositionen zurück
Function Get-JumboPos {
  [CmdletBinding()]
  Param(
    $Path
  )

  Function Get-Record {
    Param(
      $record
    )

    $Zeile = [int]$record[0]
    $length = $record[2]
    $BelNr = $record[3..(3+$length-1)] -join ''
    $length = $record[8]
    $Text = $record[9..(9+$length-1)] -join ''
    [PSCustomObject]@{Zeile=$Zeile;BelNr=$BelNr;Text=$Text}
  }

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
