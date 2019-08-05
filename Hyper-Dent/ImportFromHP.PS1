# Routinen zum Import von Daten aus Hyper-Dent

# Zunächst mal allgemein benötigte Funktionen
. .\HelperFunctions.PS1

# Wichtige Funktion, damit Zahlen korrekt exportiert werden:
#[System.Threading.Thread]::CurrentThread.CurrentCulture.NumberFormat.NumberDecimalSeparator="."

# ausführliche Variante
$CultureName = [System.Threading.Thread]::CurrentThread.CurrentCulture.Name
$CultureInfo = [System.Threading.Thread]::CurrentThread.CurrentCulture.Clone()
#$CultureInfo = New-Object [System.Threading.Thread.CultureInfo]   ($CultureName);
#$CultureInfo = [CultureInfo]::new($CultureName);
if ($CultureInfo.NumberFormat.NumberDecimalSeparator -ne ".") {
    # Forcing use of decimal separator for numerical values
    $CultureInfo.NumberFormat.NumberDecimalSeparator = ".";
    $CultureInfo.IsReadOnly
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $CultureInfo;
}

# $expPath=& {throw "Pfad für CSV-Dateien zuweisen, externe Platte"}
$expPath=(Resolve-Path ".\Export").Path
$DelaproPath = "C:\DELAGAME"

# Parameter für Parameter-Splatting
# Anwendung über @Encoding anstatt -Encoding OEM
$Encoding=@{Encoding="OEM"}

# muss für den endgültigen Übernahmelauf auf $false gesetzt werden!
# verwendet zur schnelleren Analyse immer nur einen Teil der Daten
$debug = $false
# muss für den endgültigen Übernahmelauf auf $false gesetzt werden!
# importiert die Daten nicht ins Delapro
$ignoreImport = $false

# Benutzername und Passwort für den Zugriff auf die Datenbank
$user = "sa"
$pass = ""

# Name der SQL-Server-Instanz
$SQLInstanz = '.\SQLEXPRESS'

$location = Get-Location
Import-Module sqlps -DisableNameChecking
Set-Location -Path $location
$sm = New-Object Microsoft.SqlServer.Management.Smo.Server $SQLInstanz

# Startzeit merken
$startZeit = Get-Date

# abt_termvorgabe
. .\Import\abteilung.PS1
# adr_ansprech
# adr_arten
# adr_auf_intern
# adr_bewertung
# adr_infos
# adr_kunden    # enthält kundenspezifische Einstellung für MwSt, Zahlungsbedingungen, ZANr-Vorgabe usw.
# adr_liefer
# adr_print
# adr_telnr
# adr_text
. .\Import\adressen.PS1
. .\Import\art_ausgang.PS1
# art_eingang
# art_inventur
# artikel_lager
# auf_abt_monitor
# auf_anlief
# auf_art_abt
# auf_bild
# auf_infos
# auf_jumbo
# auf_knd_monitor
# auf_knd_pos
# auf_mit_monitor
# auf_termin
# auf_variodata
. .\Import\aufkopf.PS1
# auflock -> Infos über Benutzer und Computer wo Aufträge sperren
. .\Import\aufpos.PS1
# befund
# bestellkopf
# bestellpos
. .\Import\beztexte2.PS1
# buchung
# dtproperties
. .\Import\feiertage.PS1
# fir_bankverb
# fir_orte
# firma
# firma_l
# firma_text
# formular_verkn
# jumbo_bild
# jumbo_pos
# jumbo_zuschuss
# kalkulation
# karte
. .\Import\konten.PS1
# land
# memo
# mit_abt
# mit_url_jahr
. .\Import\mitarbeiter.PS1
# muster_bilder
# mwst
# notizen
# outlook_id
# param_date
# param_long
# param_text
# pos_file
# pos_hierachie
# pos_material
# pos_memo
# pos_preise
# pos_preise_neu
. .\Import\positionen.PS1
# rechte_mit
# reise_abrech
. .\Import\sammelrech.PS1
# termine
# zahlbed
# zahlungen
# zahn_schema

# EndZeit merken
$endZeit = Get-Date

If (-Not $ignoreImport) {

    Write-Error "TODO: Nummern in Nummern.DBF setzen, Auftrag, Kunde, Techniker, Jumbos sowie evtl. Archiv=1 unter Modus in DLP_Main.INI setzen"

    # Eigentlichen Import ins Delapro durchführen
    Set-Location $DelaproPath
    $csv=get-item "$($expPath)\*.csv"
    $csv | ForEach-Object { copy-item -Path $_  -Destination $DelaproPath  -Verbose }
    $csv | ForEach-Object {$_.Name; .\DLPImport.exe ($_.Name) /AUTOIMPORT /ZAP }
    .\KILLNTX.BAT

}

# Zeiten ausgeben
$startZeit
$endZeit
"Dauer der Konvertierung ohne Import: $($endZeit - $startZeit)"

If ($Error.Count -gt 0) {
' Unbedingt $error abfragen um unnötige Exceptions zu erkennen!!'
"Fehler: $($Error.Count)"
# wenn sich bei mehrfachen Aufrufen zu viele Fehler ansammeln, kann man diese mittels $Error.Clear() löschen
}
