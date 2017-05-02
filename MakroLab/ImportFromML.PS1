# Routinen zum Import von Daten aus MakroLab

# Enumeration einführen
Add-Type -TypeDefinition @"
   public enum MLVariante
   {
      Paradox,
      SqlServer
   }
"@

# TODO: sollte abhängig von der Umgebung ermittelt werden!
$Modus = [MLVariante]::Paradox

# Zunächst mal allgemein benötigte Funktionen
. .\HelperFunctions.PS1
. .\HelperParadox.PS1

# Wichtige Funktion, damit Zahlen korrekt exportiert werden:
[System.Threading.Thread]::CurrentThread.CurrentCulture.NumberFormat.NumberDecimalSeparator="."

$expPath=& {throw "Pfad für CSV-Dateien zuweisen, externe Platte"}
$DelaproPath = "C:\DELAGAME"

# Parameter für Parameter-Splatting
# Anwendung über @Encoding anstatt -Encoding OEM
$Encoding=@{Encoding="OEM"}

If ($Modus -eq [MLVariante]::SqlServer) {
    $user = "sa"
    $pass = "I#d3K5l5d3W5"

    import-module sqlps -DisableNameChecking
    $sm = New-Object Microsoft.SqlServer.Management.Smo.Server '.\DATEXTSQLE'
} else {
    # Pseudovariable um Fehlermeldungen zu vermeiden
    $sm=[PSCustomObject]@{Databases=@("Nix")}
    # Pfad der *.DB-Dateien
    $Daten = "C:\Datext\MakroLab\Daten\"
    Open-DBConnection -Daten $Daten

}

. .\Import\ArbArt.PS1
. .\Import\AbtBez.PS1
. .\Import\ReBu.PS1
. .\Import\RechPos.PS1
. .\Import\DParam.PS1
. .\Import\DParam2.PS1
# DKDZUS enthält viele weitere Parameter für Skonto usw. für Kunden
# ERLUMS enthält die Umsätze der einzelnen Jahre jeweils für die einzelnen Monate
# BELEGSPRACHEN enthält Text für verschiedene Sprachen
$kunMonat = " 2"
$kunJahr = "17"
. .\Import\Adressen.PS1
. .\Import\DUsr.PS1
# MWSTSATZ enthält die MwSt-Sätze
. .\Import\BelegArt.PS1
. .\Import\Beleg.PS1
. .\Import\BelegZus.PS1
. .\Import\BZeilen.PS1
# BZEILENSPLIT enthält die Auftragspositionen, wo ein Technikersplitting stattfand
. .\Import\Artikel.PS1
. .\Import\MNGruppe.PS1
# __VERSION enthält die Programmversion im Feld Version sowie den Pfad zu den Daten, welcher C:\DATEXT\MakroLab\Daten ist.
# "SELECT * FROM [__Version]"
# ARTUMS enthält die Artikelumsätze?
# ARTREF enthält Beziehungen der einzelnen Positionen zueinander. Die Referenznummer verweist zum Beispiel von der neuen BEL2 auf die alte BEL2, kann aber auch auf passende 
#   BEB oder BEBZ-Positionen verweisen.
# DTEUMS enthält die Techniker für die einzelnen Monate
# DKDUMS enthält die Kundenumsätze für die einzelnen Monate
# DTEZUS enthält Zusatzinfos zu Technikern, unter anderm Daten wie Eintrittsdatum, Urlaub , Provisionsanteile.
# EMAIL enthält Infos wann ein KV (PDF) oder eine XML-Datei rausging
# FLOSKEL enthält Vorgabefloskeltexte, z. B. für E-Mails
# DATEVPAR Datev-Schnittstelle?
# ABRINFO Abrechnungstexte für Leistungspositionen? Sind die Erklärungstexte wie Memofelder bei Leistungen im Delapro
# REPORTSX - Zuordnung zwischen aussagekräftigem Namen und Crystal-Reports-Dateiname


#D vorab für Duolab?
#KD steht generell für Kunde
#TE steht generell für Techniker

# MATINFO enthält Materialzusammensetzungen und Bestandteile
# MNZEILEN enthält die Zeilen für den Materialnachweis mit Verweis auf Beleg, Charge
# MNPos und MNLink gehören auch irgendwie zum Materialnachweis und MNZeilen.
# MATBEWEG Materialbewegungsdatei
. .\Import\Jumbo.PS1
. .\Import\JumZeil.PS1
. .\Import\ZFarben.PS1

# QUALITAT Sind die Kopfzeilen für die QS-Dental Prüfliste, die mit Ja/Nein beantwortet werden müssen.
# QUALKOPF Sind die Unterpunkte von QUALITAT, es sind einzelne Fragen für den Techniker


Write-Error "Nummern in Nummern.DBF setzen, Auftrag, Kunde, Techniker, Jumbos"


# Eigentlichen Import ins Delapro durchführen
Set-Location $DelaproPath
$csv=get-item F:\export\*.csv
$csv | % { copy-item -Path $_  -Destination $DelaproPath  -Verbose }
$csv | % {$_.Name; .\DLPImport.exe ($_.Name) /AUTOIMPORT /ZAP }
.\KILLNTX.BAT
