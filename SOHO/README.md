# Notizen zu SOHO

## Firebird 3 oder 4?
Verwendet Firebird. https://firebirdsql.org/

Aktuell verfügbar ist Firebird Version 4. 
Wenn installiert, befinden sich Tools im Verzeichnis 'C:\Program Files\Firebird\Firebird_4_0'.
Dort findet man z. B. gstat.exe womit man Informationen zu einer Datenbankdatei in Erfahrung bringen kann:
```CMD
.\gstat.exe -h C:\temp\TEST.FDB

Database "C:\TEMP\TEST.FDB"
Gstat execution time Mon Dec 19 13:29:03 2022

Database header page information:
        Flags                   0
        Generation              14
        System Change Number    0
        Page size               8192
        ODS version             13.0
        Oldest transaction      3
        Oldest active           4
        Oldest snapshot         4
        Next transaction        10
        Sequence number         0
        Next attachment ID      6
        Implementation          HW=AMD/Intel/x64 little-endian OS=Windows CC=MSVC
        Shadow count            0
        Page buffers            0
        Next header page        0
        Database dialect        3
        Creation date           Dec 19, 2022 11:49:58
        Attributes              force write

    Variable header data:
        Database GUID:  {1B41DD3C-6114-4E9B-8DD8-C8B0FC06EDF7}
        *END*
Gstat completion time Mon Dec 19 13:29:04 2022
```
ODS steht für 'On Disk Structure'.
Hier gibt es Informationen zu 'ODS version': https://ib-aid.com/en/articles/all-firebird-and-interbase-on-disk-structure-ods-versions/
siehe auch: https://stackoverflow.com/questions/49338030/how-to-easily-determine-version-of-fdb-file-firebird-database

Für direkte Interaktionen gibt es das SQL-Utility iSQL.EXE.

Versucht man mit Firebird 4 eine SOHO-Datenbank zu öffnen erhält man diese Meldung:

```
SQL> connect c:\temp\sohotech.fdb;
Statement failed, SQLSTATE = HY000
unsupported on-disk structure for file C:\TEMP\SOHOTECH.FDB; found 12.0, support 13.0
```

analog gibt es eine Fehlermeldung bei Aufruf über gstat.exe

```
PS C:\Program Files\Firebird\Firebird_4_0> .\gstat.exe -h C:\temp\SOHOTECH.FDB
Wrong ODS version, expected 13, encountered 12
```

> 🟥 Es muss also zwingend Firebird 3 für den Zugriff verwendet werden!

Man benötigt also z. B. diese Version: https://github.com/FirebirdSQL/firebird/releases/download/v3.0.10/Firebird-3.0.10.33601_0_x64.exe.

Bei Verwendung von Firebird 3.x erhält man diese Ausgabe:

```
PS C:\Program Files\Firebird\Firebird_3_0> .\gstat.exe -h C:\temp\SOHOTECH.FDB

Database "C:\TEMP\SOHOTECH.FDB"
Gstat execution time Thu Dec 29 22:41:39 2022

Database header page information:
        Flags                   0
        Generation              1652886
        System Change Number    0
        Page size               4096
        ODS version             12.0
        Oldest transaction      1651642
        Oldest active           1651643
        Oldest snapshot         1651643
        Next transaction        1651648
        Sequence number         0
        Next attachment ID      16094
        Implementation          HW=AMD/Intel/x64 little-endian OS=Windows CC=MSVC
        Shadow count            0
        Page buffers            0
        Next header page        0
        Database dialect        3
        Creation date           Jan 16, 2019 16:21:01
        Attributes              force write

    Variable header data:
        Sweep interval:         20000
        *END*
Gstat completion time Thu Dec 29 22:41:39 2022
```

Somit klappt es auch mit ISQL.EXE:

```
PS C:\Program Files\Firebird\Firebird_3_0> .\isql.exe
Use CONNECT or CREATE DATABASE to specify a database
SQL> connect c:\temp\sohotech.fdb;
Database: c:\temp\sohotech.fdb, User: ADMIN
SQL> show database;
Database: c:\temp\sohotech.fdb
        Owner: SYSDBA
PAGE_SIZE 4096
Number of DB pages allocated = 73100
Number of DB pages used = 70482
Number of DB pages free = 2618
Sweep interval = 20000
Forced Writes are ON
Transaction - oldest = 1651655
Transaction - oldest active = 1651656
Transaction - oldest snapshot = 1651656
Transaction - Next = 1651668
ODS = 12.0
Database not encrypted
Creation date: Jan 16, 2019 16:21:01
Default Character set: WIN1252
```

Um per Powershell auf Firebird-SQL-Server zugreifen zu können kann man InvokeQuery verwenden: https://www.powershellgallery.com/packages/InvokeQuery/1.0.2. Es bringt die Funktion <code>Invoke-FirebirdQuery</code> mit.

Beispiel: https://stackoverflow.com/questions/58501690/connection-to-firebird-from-powershell-script

Oder per ODBC: https://stackoverflow.com/questions/18704610/powershell-connect-to-firebird

Informationen zum Datenverzeichnis: https://web.archive.org/web/20161106222227/http://soho-soft.de/index.php/tipps-tricks.

## Datenstruktur

In ISql kann man mittels

```
SQL> show tables;
       SOHODBPP                               SOHODBZA
       SOHOETIK                               SOHOGINI
       SOHOKALK                               SOHONDSP
       SOHOSEPA                               SOHOSYS1
       SOHOTEAE                               SOHOTEAK
       SOHOTEAR                               SOHOTEAU
       SOHOTEKD                               SOHOTEPE
       SOHOTEPG                               SOHOTEPR
       SOHOTESK                               SOHOTEST
       SOHOTETX                               SOHOZAHN
```

die Tabellen ausgeben und mittels

```
show index;
```

die Indizes ausgeben lassen:

```
RDB$PRIMARY1 UNIQUE INDEX ON SOHODBPP(KENNUNG, NACHNAME, VORNAME, ANREDE, RECHNUNGSDATUM, AUFTRAGSNR, KUNDENNUMMER, RECHNUNGSNR)
RDB$PRIMARY2 UNIQUE INDEX ON SOHODBZA(NACHNAME, VORNAME, ANREDE, RECHNUNGSDATUM, AUFTRAGSNR, KUNDENNUMMER, RECHNUNGSNR, ABTEILUNG, OKUK)
RDB$PRIMARY3 UNIQUE INDEX ON SOHOETIK(NAMEETIKETT)
RDB$PRIMARY4 UNIQUE INDEX ON SOHOKALK(SATZNR, TABELLE)
RDB$PRIMARY5 UNIQUE INDEX ON SOHONDSP(DATEINAME)
RDB$PRIMARY19 UNIQUE INDEX ON SOHOSEPA(SATZART, KUNDENNUMMER, RECHNUNGSNUMMER)
RDB$PRIMARY6 UNIQUE INDEX ON SOHOSYS1(LFDNR)
RDB$PRIMARY7 UNIQUE INDEX ON SOHOTEAE(AUFTRAGSNUMMER, ABTEILUNG, OKUK, ZEILENNUMMER)
RDB$PRIMARY8 UNIQUE INDEX ON SOHOTEAK(KUNDENNUMMER, ABTEILUNG)
RDB$PRIMARY9 UNIQUE INDEX ON SOHOTEAR(TABELLE, BELNR, BELNRERWEITERUNG)
RDB$PRIMARY10 UNIQUE INDEX ON SOHOTEAU(AUFTRAGSNUMMER, ABTEILUNG, OKUK)
RDB$PRIMARY11 UNIQUE INDEX ON SOHOTEKD(KUNDENNUMMER)
RDB$PRIMARY12 UNIQUE INDEX ON SOHOTEPE(TABELLE, RECHNUNGSNUMMER, ZEILENNUMMER)
RDB$PRIMARY13 UNIQUE INDEX ON SOHOTEPG(BELNR, RECHNUNGSNUMMER, ZEILENNUMMER)
RDB$PRIMARY14 UNIQUE INDEX ON SOHOTEPR(TABELLE, RECHNUNGSNUMMER)
RDB$PRIMARY15 UNIQUE INDEX ON SOHOTESK(TABELLE, ZEITRAUM, KUNDENNUMMER, BELNR)
RDB$PRIMARY16 UNIQUE INDEX ON SOHOTEST(TABELLE, ZEITRAUM, BELNR)
RDB$PRIMARY17 UNIQUE INDEX ON SOHOTETX(TABELLE, PLZNR, PLZNRERGAENZUNG)
RDB$PRIMARY18 UNIQUE INDEX ON SOHOZAHN(SATZNR)
```

Um mehr Informationen über die einzelnen Tabellen zu bekommen, lesen wir diese zunächst per Powershell ein

```Powershell
# der Pfad C:\temp muss existieren, der aktuelle Pfad muss C:\Program Files\Firebird\Firebird_3_0 sein
# erzeugt ein SQL-Script zum Ausführen
'CONNECT C:\temp\sohotech.fdb;Show Tables;'|Set-Content c:\temp\script.sql
$Tables=.\isql.exe -i C:\temp\script.sql -q
# doppelte Spaltenausgabe auflösen und reinen Tabellennamen ermitteln
$Tables=($Tables -split ' ') | where length -gt 0
# Jetzt kann $Tables für weitere Zwecke verwendet werden

```

Man kann zwar die Datenbank einfach öffnen aber tatsächlich Zugriff auf den Inhalt bekommt man erst wenn man sich als SYSDBA mit dem Passwort, welches man bei der Installation für den SYSDBA vergeben hat anmeldet. Beim Aufruf von ISQL.EXE kann man mittels Parameter -u SYSDBA und -p PASSWORT die Parameter direkt mitgeben.

Hier werden einfach mal ein paar SQL-Abfragen aufgeführt und etwaige Hinweise dazu beschrieben:

Anzahl der Datensätze ermitteln, wie gewohnt:
```
SQL> select COUNT(*) FROM SOHODBPP;

                COUNT
=====================
                90672
```

Rechnungsnummer, Auftragsnummer, Kundennummer und Rechnungsdatum ermitteln:
```
SQL> select Rechnungsnr,Auftragsnr,Kundennummer,Rechnungsdatum FROM SOHODBPP ORDER BY rechnungsdatum DESC FETCH FIRST 10 ROWS ONLY;
          RECHNUNGSNR            AUFTRAGSNR KUNDENNUMMER RECHNUNGSDATUM
===================== ===================== ============ ==============
            167220147                     0          167 2022-12-27
            167220147                     0          167 2022-12-27
            103220217                114749          103 2022-12-23
            103220217                114749          103 2022-12-23
            105220379                114810          105 2022-12-23
            105220379                114810          105 2022-12-23
            108220157                114717          108 2022-12-23
            108220157                114717          108 2022-12-23
            125220263                     0          125 2022-12-23
            125220263                     0          125 2022-12-23
```            
            
Die Rechnungsnummer scheint nach dem Schema <Kundennummer><Jahr zweistellig><laufende Rechnungsnummer im Monat> aufgebaut zu sein.
Warum aber existiert keine Auftragsnummer obwohl eine Rechnungsnummer existiert?!?


Ausgabe der Kundennummern
```
SQL> select Kundennummer FROM SOHOTEKD ORDER BY Kundennummer DESC FETCH FIRST 10 ROWS ONLY;

KUNDENNUMMER
============
         999
         901
         900
         633
         631
         630
         628
         625
         618
         610
```
