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

Automatisiert einen Überblick bekommen, in welchen Tabellen wieviel Datensätze stecken:
```
"CONNECT C:\temp\sohotech.fdb;"|Set-Content c:\temp\script.sql
$tables|%{"SELECT COUNT(*) AS $($_)_COUNT FROM $_;"}|Add-Content C:\temp\script.sql
.\isql.exe -i C:\temp\script.sql -q -user sysdba -p easy1
        
       SOHODBPP_COUNT
=====================
                90672


       SOHODBZA_COUNT
=====================
                    3


       SOHOETIK_COUNT
=====================
                    0


       SOHOGINI_COUNT
=====================
                 2022


       SOHOKALK_COUNT
=====================
                    6


       SOHONDSP_COUNT
=====================
                    4


       SOHOSEPA_COUNT
=====================
                    0


       SOHOSYS1_COUNT
=====================
                    1


       SOHOTEAE_COUNT
=====================
                 1855


       SOHOTEAK_COUNT
=====================
                    0


       SOHOTEAR_COUNT
=====================
                 2278


       SOHOTEAU_COUNT
=====================
                   99


       SOHOTEKD_COUNT
=====================
                  121


       SOHOTEPE_COUNT
=====================
              1348396


       SOHOTEPG_COUNT
=====================
                28618


       SOHOTEPR_COUNT
=====================
                66520


       SOHOTESK_COUNT
=====================
                59218


       SOHOTEST_COUNT
=====================
                53494


       SOHOTETX_COUNT
=====================
                 2416


       SOHOZAHN_COUNT
=====================
                    0
```

So wie es aussieht enthält SOHOTEPE die Auftrags- bzw. Rechnungspositionen:
```
SQL> select Tabelle, Rechnungsnummer, Zeilennummer,Status,Datum,BelNr,Bezeichnung FROM SOHOTEPE order by Datum desc FET
H FIRST 10 ROWS ONLY;

     TABELLE       RECHNUNGSNUMMER ZEILENNUMMER STATUS       DATUM BELNR    BEZEICHNUNG
============ ===================== ============ ====== =========== ======== ===========================================
===================================
           0                919610           13 1      2022-12-27    001.0  Modell
           0                919610            4 1      2022-12-27    005.1  Sõgemodell
           0                919610           15 1      2022-12-27    005.1  Sõgemodell
          20                102201            1 0      2022-12-27       -1  Oberkiefer
           0                919610           12 1      2022-12-27       -2  Unterkiefer
           0                919610           29 0      2022-12-27           \27.12.20221
```
        
gezielte Ausgabe der Positionen eines Auftrags bzw. Rechnung:
```
SQL> select Rechnungsnummer, Zeilennummer,Status,Datum,BelNr,Bezeichnung FROM SOHOTEPE WHERE Rechnungsnummer = '919300';

      RECHNUNGSNUMMER ZEILENNUMMER STATUS       DATUM BELNR    BEZEICHNUNG
===================== ============ ====== =========== ======== ===============================================================================
               919300            1 1      2022-09-15       -1  Oberkiefer
               919300            2 1      2022-09-15    001.0  Modell
               919300            3 1      2022-09-15    002.3  Verwendung von Kunststoff
               919300            4 1      2022-09-15    005.1  Sõgemodell
               919300            5 1      2022-09-15    012.0  Mittelwertartikulator
               919300            6 1      2022-09-15    102.4  Krone f³r vestibulõre Verblendung
               919300            7 1      2022-09-15    110.0  Br³ckenglied
               919300            8 1      2022-09-15    162.0  Vestibulõre Verblendung Keramik
               919300            9 1      2022-09-15     2123  Stufenkrone gegossen, f³r Keramik o. Komposite - Teilverblendung
               919300           10 1      2022-09-15     2611  Teil-Verblendung  aus Keramik
               919300           11 1      2022-09-15    933.0  Versandkosten
               919300           12 1      2022-09-15    970.0  Verarbeitungsaufwand NEM-Legierung
               919300           13 1      2022-09-15   991013  Quattrodisk NEM Soft CoCr
               919300           14 1      2022-09-15   900000  Noritake Ex-3
               919300           15 0      2022-09-15           \Quattrodisk NEM Soft CoCr              Goldquadrat                             CE=ja Co 63,0, Cr 29,0, Mo 6,0, Mn x, Nb x, Si x, Fe x
               919300           16 0      2022-09-15           \Noritake Ex-3                          Noritake
                       CE=ja
               919300           17 0      2022-09-15           \OK 15-23 KV 24,25 BV 26 KV NE
               919300           18 0      2022-09-15           \M
               919300           19 0      2022-09-15           \15.09.20221
```

So jetzt brauchen wir einen Überblick über die Felder der einzelnen Tabellen
```
"CONNECT C:\temp\sohotech.fdb;"|Set-Content c:\temp\script.sql
$Struktur=@"
SELECT R.RDB`$FIELD_NAME AS Tabelle_field_name,
CASE F.RDB`$FIELD_TYPE
 WHEN 7 THEN 'SMALLINT'
 WHEN 8 THEN 'INTEGER'
 WHEN 9 THEN 'QUAD'
 WHEN 10 THEN 'FLOAT'
 WHEN 11 THEN 'D_FLOAT'
 WHEN 12 THEN 'DATE'
 WHEN 13 THEN 'TIME'     
 WHEN 14 THEN 'CHAR'
 WHEN 16 THEN 'INT64'
 WHEN 27 THEN 'DOUBLE'
 WHEN 35 THEN 'TIMESTAMP'
 WHEN 37 THEN 'VARCHAR'
 WHEN 40 THEN 'CSTRING'
 WHEN 261 THEN 'BLOB'
 ELSE 'UNKNOWN'
END AS field_type,
F.RDB`$FIELD_LENGTH AS field_length,
CSET.RDB`$CHARACTER_SET_NAME AS field_charset
FROM RDB`$RELATION_FIELDS R
LEFT JOIN RDB`$FIELDS F ON R.RDB`$FIELD_SOURCE = F.RDB`$FIELD_NAME
LEFT JOIN RDB`$CHARACTER_SETS CSET ON F.RDB`$CHARACTER_SET_ID = CSET.RDB`$CHARACTER_SET_ID
WHERE R.RDB`$RELATION_NAME='Tabelle'
ORDER BY R.RDB`$FIELD_POSITION
"@
$tables|%{"$($Struktur.Replace('Tabelle', $_));"}|Add-Content C:\temp\script.sql
.\isql.exe -i C:\temp\script.sql -q -user sysdba -p easy1
```

Obiges Script sieht etwas wirr aus, liefert aber alles was benötigt wird. Zu beachten sind zwei Stellen in denen Tabelle durch den tatsächlichen Tabellennamen ersetzt wird, damit eine Zuordnung zwischen Feldname und Tabelle möglich wird.
        
Hier das Ergebnis
```
SOHODBPP_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
KENNUNG                         INTEGER               4 <null>
NACHNAME                        VARCHAR              30 WIN1252
VORNAME                         VARCHAR              30 WIN1252
ANREDE                          VARCHAR              30 WIN1252
RECHNUNGSDATUM                  DATE                  4 <null>
AUFTRAGSNR                      INT64                 8 <null>
KUNDENNUMMER                    INTEGER               4 <null>
RECHNUNGSNR                     INT64                 8 <null>
TEXT1                           VARCHAR              30 WIN1252
TEXT2                           VARCHAR              30 WIN1252
TEXT3                           VARCHAR              30 WIN1252
TEXT4                           VARCHAR              30 WIN1252
TEXT5                           VARCHAR              30 WIN1252
TEXT6                           VARCHAR              30 WIN1252
TEXT7                           VARCHAR              30 WIN1252
TEXT8                           VARCHAR              30 WIN1252
TEXT9                           VARCHAR              30 WIN1252
TEXT10                          VARCHAR              30 WIN1252
TEXT11                          VARCHAR              30 WIN1252
TEXT12                          VARCHAR              30 WIN1252
TEXT13                          VARCHAR              30 WIN1252
TEXT14                          VARCHAR              30 WIN1252
TEXT15                          VARCHAR              30 WIN1252
TEXT16                          VARCHAR              30 WIN1252
TEXT17                          VARCHAR              30 WIN1252
ART1                            FLOAT                 4 <null>
ART2                            FLOAT                 4 <null>
ART3                            FLOAT                 4 <null>
ART4                            FLOAT                 4 <null>
ART5                            FLOAT                 4 <null>
ART6                            FLOAT                 4 <null>
ART7                            FLOAT                 4 <null>
ART8                            FLOAT                 4 <null>
ART9                            FLOAT                 4 <null>
ART10                           FLOAT                 4 <null>
ART11                           FLOAT                 4 <null>
ART12                           FLOAT                 4 <null>
ART13                           FLOAT                 4 <null>
ART14                           FLOAT                 4 <null>
ART15                           FLOAT                 4 <null>
ART16                           FLOAT                 4 <null>
ART17                           FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
VERSSTATUS                      VARCHAR               2 WIN1252


SOHODBZA_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
SATZNR                          INTEGER               4 <null>
NACHNAME                        VARCHAR              30 WIN1252
VORNAME                         VARCHAR              30 WIN1252
ANREDE                          VARCHAR              30 WIN1252
RECHNUNGSDATUM                  DATE                  4 <null>
AUFTRAGSNR                      INT64                 8 <null>
KUNDENNUMMER                    INTEGER               4 <null>
RECHNUNGSNR                     INT64                 8 <null>
ABTEILUNG                       VARCHAR               4 WIN1252
OKUK                            VARCHAR               2 WIN1252
ZAHN01                          CHAR                 50 WIN1252
ZAHN02                          CHAR                 50 WIN1252
ZAHN03                          CHAR                 50 WIN1252
ZAHN04                          CHAR                 50 WIN1252
ZAHN05                          CHAR                 50 WIN1252
ZAHN06                          CHAR                 50 WIN1252
ZAHN07                          CHAR                 50 WIN1252
ZAHN08                          CHAR                 50 WIN1252
ZAHN09                          CHAR                 50 WIN1252
ZAHN10                          CHAR                 50 WIN1252
ZAHN11                          CHAR                 50 WIN1252
ZAHN12                          CHAR                 50 WIN1252
ZAHN13                          CHAR                 50 WIN1252
ZAHN14                          CHAR                 50 WIN1252
ZAHN15                          CHAR                 50 WIN1252
ZAHN16                          CHAR                 50 WIN1252
ZAHN17                          CHAR                 50 WIN1252
ZAHN18                          CHAR                 50 WIN1252
ZAHN19                          CHAR                 50 WIN1252
ZAHN20                          CHAR                 50 WIN1252
ZAHN21                          CHAR                 50 WIN1252
ZAHN22                          CHAR                 50 WIN1252
ZAHN23                          CHAR                 50 WIN1252
ZAHN24                          CHAR                 50 WIN1252
ZAHN25                          CHAR                 50 WIN1252
ZAHN26                          CHAR                 50 WIN1252
ZAHN27                          CHAR                 50 WIN1252
ZAHN28                          CHAR                 50 WIN1252
ZAHN29                          CHAR                 50 WIN1252
ZAHN30                          CHAR                 50 WIN1252
ZAHN31                          CHAR                 50 WIN1252
ZAHN32                          CHAR                 50 WIN1252
SPEICHER33                      CHAR                 50 WIN1252
SPEICHER34                      CHAR                 50 WIN1252
SPEICHER35                      CHAR                 50 WIN1252
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOETIK_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
NAMEETIKETT                     VARCHAR              40 WIN1252
OBERERRAND                      FLOAT                 4 <null>
SEITENRAND                      FLOAT                 4 <null>
VERTIKALABSTAND                 FLOAT                 4 <null>
HORIZONTALABSTAND               FLOAT                 4 <null>
ETIKETTENHOEHE                  FLOAT                 4 <null>
ETIKETTENBREITE                 FLOAT                 4 <null>
ANZAHLINZEILE                   FLOAT                 4 <null>
ANZAHLINSPALTE                  FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOGINI_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
KENNUNG                         INTEGER               4 <null>
FIRMA                           INTEGER               4 <null>
SECTION                         VARCHAR              30 WIN1252
IDENT                           VARCHAR              60 WIN1252
EINTRAG                         VARCHAR              90 WIN1252
ERLAEUTERUNG                    VARCHAR              90 WIN1252
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOKALK_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
SATZNR                          INTEGER               4 <null>
TABELLE                         INTEGER               4 <null>
RUESTZEIT0                      FLOAT                 4 <null>
RUESTZEIT1                      FLOAT                 4 <null>
RUESTZEIT2                      FLOAT                 4 <null>
RUESTZEIT3                      FLOAT                 4 <null>
RUESTZEIT4                      FLOAT                 4 <null>
RUESTZEIT5                      FLOAT                 4 <null>
RUESTZEIT6                      FLOAT                 4 <null>
RUESTZEIT7                      FLOAT                 4 <null>
RUESTZEIT8                      FLOAT                 4 <null>
RUESTZEIT9                      FLOAT                 4 <null>
KSATZ0                          FLOAT                 4 <null>
KSATZ1                          FLOAT                 4 <null>
KSATZ2                          FLOAT                 4 <null>
KSATZ3                          FLOAT                 4 <null>
KSATZ4                          FLOAT                 4 <null>
KSATZ5                          FLOAT                 4 <null>
KSATZ6                          FLOAT                 4 <null>
KSATZ7                          FLOAT                 4 <null>
KSATZ8                          FLOAT                 4 <null>
KSATZ9                          FLOAT                 4 <null>
STDSATZ0                        FLOAT                 4 <null>
STDSATZ1                        FLOAT                 4 <null>
STDSATZ2                        FLOAT                 4 <null>
STDSATZ3                        FLOAT                 4 <null>
STDSATZ4                        FLOAT                 4 <null>
STDSATZ5                        FLOAT                 4 <null>
STDSATZ6                        FLOAT                 4 <null>
STDSATZ7                        FLOAT                 4 <null>
STDSATZ8                        FLOAT                 4 <null>
STDSATZ9                        FLOAT                 4 <null>
FELD1                           FLOAT                 4 <null>
FELD2                           FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHONDSP_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
DATEINAME                       VARCHAR              30 WIN1252
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOSEPA_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
SATZART                         INTEGER               4 <null>
KUNDENNUMMER                    INTEGER               4 <null>
RECHNUNGSNUMMER                 INT64                 8 <null>
AUFNAHMEDATUM                   DATE                  4 <null>
AUFNAHMEZEIT                    TIME                  4 <null>
KUNDENNAME                      VARCHAR              30 WIN1252
LASTSCHRIFTART                  VARCHAR              10 WIN1252
MANDAT                          VARCHAR              16 WIN1252
MANDATDATUM                     VARCHAR              10 WIN1252
SEQUENZ                         VARCHAR              20 WIN1252
IBAN                            VARCHAR              35 WIN1252
BIC                             VARCHAR              16 WIN1252
VERWENDUNGSZWECK                VARCHAR              30 WIN1252
TERMIN                          DATE                  4 <null>
BETRAG                          FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
TERMININT                       INT64                 8 <null>


SOHOSYS1_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
LFDNR                           INTEGER               4 <null>
MODUS                           INTEGER               4 <null>
SAMMELRNR                       INT64                 8 <null>
LAUFTRAGSNR                     INT64                 8 <null>
LAND                            VARCHAR               2 WIN1252
GOLDAUFSCHL                     FLOAT                 4 <null>
LRECHNR                         INT64                 8 <null>
LKVRECHNR                       INT64                 8 <null>
HKRECHNR                        INT64                 8 <null>
KULRECHNR                       INT64                 8 <null>
REKLAMRECHNR                    INT64                 8 <null>
WERBUNGRECHNR                   INT64                 8 <null>
SONSTRECHNR                     INT64                 8 <null>
MWST1                           FLOAT                 4 <null>
MWST2                           FLOAT                 4 <null>
MWSTBISDATUM                    DATE                  4 <null>
MWSTBIS1                        FLOAT                 4 <null>
MWSTBIS2                        FLOAT                 4 <null>
ZUSATZ1                         VARCHAR              30 WIN1252
ZUSATZ2                         VARCHAR              30 WIN1252
ZUSATZ3                         VARCHAR              30 WIN1252
ZUSATZ4                         VARCHAR              30 WIN1252
AUSDR                           VARCHAR               2 WIN1252
SEITE                           VARCHAR               2 WIN1252
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
LABORNAME                       VARCHAR              50 WIN1252
LABORID                         VARCHAR              50 WIN1252
HERSTLAND                       VARCHAR              10 WIN1252
HERSTORT                        VARCHAR              50 WIN1252
BEL2006BISDATUM                 DATE                  4 <null>


SOHOTEAE_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
AUFTRAGSNUMMER                  INT64                 8 <null>
ABTEILUNG                       VARCHAR               4 WIN1252
OKUK                            VARCHAR               2 WIN1252
ZEILENNUMMER                    INTEGER               4 <null>
STATUS                          VARCHAR               2 WIN1252
DATUM                           DATE                  4 <null>
BELNR                           VARCHAR               8 WIN1252
BEZEICHNUNG                     VARCHAR             255 WIN1252
ANZAHL                          FLOAT                 4 <null>
EINZELPREIS                     FLOAT                 4 <null>
VERBRAUCH                       FLOAT                 4 <null>
GESAMT                          FLOAT                 4 <null>
MWSTSATZ                        FLOAT                 4 <null>
VORGABEMINUTEN                  FLOAT                 4 <null>
TECHNIKER1                      VARCHAR               3 WIN1252
TECHNIKER2                      VARCHAR               3 WIN1252
TECHNIKER3                      VARCHAR               3 WIN1252
TECHNIKER4                      VARCHAR               3 WIN1252
TECHNANZAHL1                    FLOAT                 4 <null>
TECHNANZAHL2                    FLOAT                 4 <null>
TECHNANZAHL3                    FLOAT                 4 <null>
TECHNANZAHL4                    FLOAT                 4 <null>
PREISTABELLE                    INTEGER               4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTEAK_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
KUNDENNUMMER                    INTEGER               4 <null>
ABTEILUNG                       VARCHAR               4 WIN1252
BESONDERHEIT1                   VARCHAR              80 WIN1252
BESONDERHEIT2                   VARCHAR              80 WIN1252
BESONDERHEIT3                   VARCHAR              80 WIN1252
BESONDERHEIT4                   VARCHAR              80 WIN1252
BESONDERHEIT5                   VARCHAR              80 WIN1252
BESONDERHEIT6                   VARCHAR              80 WIN1252
BESONDERHEIT7                   VARCHAR              80 WIN1252
BESONDERHEIT8                   VARCHAR              80 WIN1252
BESONDERHEIT9                   VARCHAR              80 WIN1252
BESONDERHEIT10                  VARCHAR              80 WIN1252
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTEAR_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
TABELLE                         INTEGER               4 <null>
BELNR                           VARCHAR               8 WIN1252
BELNRERWEITERUNG                VARCHAR               3 WIN1252
BEZEICHNUNG                     VARCHAR             255 WIN1252
EINZELPREIS                     DOUBLE                8 <null>
RUESTZEIT                       FLOAT                 4 <null>
VERWEILZEIT                     FLOAT                 4 <null>
BEARBZEIT                       FLOAT                 4 <null>
ZUSEINGABEVONBIS                VARCHAR              14 WIN1252
ZUSEINGABE2VONBIS               VARCHAR              14 WIN1252
ZUSEINGABE3VONBIS               VARCHAR              14 WIN1252
RVOEXTRA                        VARCHAR               1 WIN1252
BELNRAUSDRUCK                   VARCHAR              10 WIN1252
ABWABTEILUNG                    INTEGER               4 <null>
MATERIALART                     INTEGER               4 <null>
HERSTELLER                      VARCHAR              30 WIN1252
BESTANDTEIL                     VARCHAR              90 WIN1252
SONSTIGES                       VARCHAR              30 WIN1252
ZUSCHLPLANZ1                    FLOAT                 4 <null>
ZUSCHLPLANZ2                    FLOAT                 4 <null>
ZUSCHLPLANZ3                    FLOAT                 4 <null>
KSTUNDENSATZ                    FLOAT                 4 <null>
KRUESTZEIT                      FLOAT                 4 <null>
ZUSCHLKUND1                     FLOAT                 4 <null>
ZUSCHLKUND2                     FLOAT                 4 <null>
ZUSCHLKUND3                     FLOAT                 4 <null>
ZUSCHLKUND4                     FLOAT                 4 <null>
KSKPREIS                        FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTEAU_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
AUFTRAGSNUMMER                  INT64                 8 <null>
ABTEILUNG                       VARCHAR               4 WIN1252
OKUK                            VARCHAR               2 WIN1252
KUNDENNUMMER                    INTEGER               4 <null>
ANREDE                          VARCHAR              30 WIN1252
VORNAME                         VARCHAR              30 WIN1252
NACHNAME                        VARCHAR              30 WIN1252
KRANKENKASSE                    VARCHAR              30 WIN1252
ZAHNFARBE                       VARCHAR              30 WIN1252
ABDRUCK                         VARCHAR              30 WIN1252
MODELL                          VARCHAR              30 WIN1252
LOEFFEL                         VARCHAR              30 WIN1252
SONSTIGES                       VARCHAR              30 WIN1252
BESONDERHEITEN1                 VARCHAR              80 WIN1252
BESONDERHEITEN2                 VARCHAR              80 WIN1252
BESONDERHEITEN3                 VARCHAR              80 WIN1252
BESONDERHEITEN4                 VARCHAR              80 WIN1252
BESONDERHEITEN5                 VARCHAR              80 WIN1252
BESONDERHEITEN6                 VARCHAR              80 WIN1252
BESONDERHEITEN7                 VARCHAR              80 WIN1252
BESONDERHEITEN8                 VARCHAR              80 WIN1252
BESONDERHEITEN9                 VARCHAR              80 WIN1252
BESONDERHEITEN10                VARCHAR              80 WIN1252
LIEFERZEIT                      TIME                  4 <null>
LIEFERTAG                       DATE                  4 <null>
PRAXISZEIT                      TIME                  4 <null>
PRAXISTAG                       DATE                  4 <null>
ERLEDIGUNGSVERMERK              VARCHAR               4 WIN1252
BEDIENER                        VARCHAR              30 WIN1252
VORGABEZEIT                     FLOAT                 4 <null>
GESAMTBETRAG                    FLOAT                 4 <null>
BEDIENER01                      FLOAT                 4 <null>
DATUM01                         DATE                  4 <null>
BEDIENER02                      FLOAT                 4 <null>
DATUM02                         DATE                  4 <null>
BEDIENER03                      FLOAT                 4 <null>
DATUM03                         DATE                  4 <null>
BEDIENER04                      FLOAT                 4 <null>
DATUM04                         DATE                  4 <null>
BEDIENER05                      FLOAT                 4 <null>
DATUM05                         DATE                  4 <null>
BEDIENER06                      FLOAT                 4 <null>
DATUM06                         DATE                  4 <null>
BEDIENER07                      FLOAT                 4 <null>
DATUM07                         DATE                  4 <null>
BEDIENER08                      FLOAT                 4 <null>
DATUM08                         DATE                  4 <null>
BEDIENER09                      FLOAT                 4 <null>
DATUM09                         DATE                  4 <null>
BEDIENER10                      FLOAT                 4 <null>
DATUM10                         DATE                  4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
XMLERGAENZUNG                   VARCHAR              51 WIN1252
XMLVERSION                      INTEGER               4 <null>


SOHOTEKD_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
KUNDENNUMMER                    INTEGER               4 <null>
KUNDENKURZNAME                  VARCHAR              60 WIN1252
ANREDE                          VARCHAR              30 WIN1252
NAME_1                          VARCHAR              30 WIN1252
NAME_2                          VARCHAR              30 WIN1252
NAME_3                          VARCHAR              30 WIN1252
NAME_4                          VARCHAR              30 WIN1252
NAME_5                          VARCHAR              30 WIN1252
NAME_6                          VARCHAR              30 WIN1252
NAME_7                          VARCHAR              30 WIN1252
ASSISTENZARZT                   VARCHAR              30 WIN1252
SONDERMERKER                    VARCHAR               5 WIN1252
RABATT_LABOR                    FLOAT                 4 <null>
RABATT_LABOR_SAMMELR            FLOAT                 4 <null>
RABATT_GESAMT_SAMMELR           FLOAT                 4 <null>
MWSTSATZ1                       FLOAT                 4 <null>
MWSTSATZ2                       FLOAT                 4 <null>
RECHNUNGSNUMMER                 INT64                 8 <null>
GEMPRAXNR                       VARCHAR               5 WIN1252
DTA_MERKER                      CHAR                  2 WIN1252
PREISTABELLE                    CHAR                  2 WIN1252
RESERVENUM1                     FLOAT                 4 <null>
RESERVENUM2                     FLOAT                 4 <null>
RESERVENUM3                     FLOAT                 4 <null>
RESERVENUM4                     FLOAT                 4 <null>
RESERVENUM5                     FLOAT                 4 <null>
RESERVENUM6                     FLOAT                 4 <null>
RESERVEALPHA1                   VARCHAR              10 WIN1252
RESERVEALPHA2                   VARCHAR              10 WIN1252
RESERVEALPHA3                   VARCHAR              10 WIN1252
RESERVEALPHA4                   VARCHAR              10 WIN1252
RESERVEALPHA5                   VARCHAR              10 WIN1252
RESERVEALPHA6                   VARCHAR              10 WIN1252
ZAHLUNGSTEXTREST                VARCHAR              30 WIN1252
MAILADRESSE                     VARCHAR              60 WIN1252
KONTONR                         VARCHAR              35 WIN1252
BANKBEZEICHNUNG                 VARCHAR              27 WIN1252
BANKLEITZAHL                    VARCHAR              16 WIN1252
GRUND01                         VARCHAR              30 WIN1252
DATUM01                         DATE                  4 <null>
GRUND02                         VARCHAR              30 WIN1252
DATUM02                         DATE                  4 <null>
GRUND03                         VARCHAR              30 WIN1252
DATUM03                         DATE                  4 <null>
ERWEITERUNG01                   VARCHAR              30 WIN1252
ERWEITERUNG02                   VARCHAR              30 WIN1252
ERWEITERUNG03                   VARCHAR              30 WIN1252
ERWEITERUNG04                   VARCHAR              30 WIN1252
ERWEITERUNG05                   VARCHAR              30 WIN1252
ERWEITERUNGNUM01                FLOAT                 4 <null>
ERWEITERUNGNUM02                FLOAT                 4 <null>
ERWEITERUNGNUM03                FLOAT                 4 <null>
ERWEITERUNGNUM04                FLOAT                 4 <null>
ERWEITERUNGNUM05                FLOAT                 4 <null>
HINWEISE                        BLOB                  8 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
ELEKTRONRNRUMFANG               INTEGER               4 <null>
ELEKTRONRNRERSATZ               INTEGER               4 <null>
ELEKTRONRNRFORMULARZUSATZ       VARCHAR              30 WIN1252
ELEKTRONRNRDOKART               INTEGER               4 <null>
ELEKTRONRNRVERSART              INTEGER               4 <null>
ELEKTRONRNRBESPASSW             VARCHAR              30 WIN1252
ELEKTRONRNRNUTZERPW             VARCHAR              30 WIN1252
SEPAMANDAT                      VARCHAR              16 WIN1252
SEPAMANDATDATUM                 VARCHAR              10 WIN1252
SEPALIC                         VARCHAR              20 WIN1252
SEPASEQUENZ                     VARCHAR              20 WIN1252
SEPAFAELLIGART                  INTEGER               4 <null>
SEPAFAELLIGPLUSTAGE             INTEGER               4 <null>
SEPARECHNUNG                    INTEGER               4 <null>


SOHOTEPE_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
TABELLE                         INTEGER               4 <null>
RECHNUNGSNUMMER                 INT64                 8 <null>
ZEILENNUMMER                    INTEGER               4 <null>
STATUS                          VARCHAR               2 WIN1252
DATUM                           DATE                  4 <null>
BELNR                           VARCHAR               8 WIN1252
BEZEICHNUNG                     VARCHAR             255 WIN1252
ANZAHL                          FLOAT                 4 <null>
EINZELPREIS                     FLOAT                 4 <null>
VERBRAUCH                       FLOAT                 4 <null>
GESAMT                          FLOAT                 4 <null>
MWSTSATZ                        FLOAT                 4 <null>
VORGABEMINUTEN                  FLOAT                 4 <null>
TECHNIKER1                      VARCHAR               3 WIN1252
TECHNIKER2                      VARCHAR               3 WIN1252
TECHNIKER3                      VARCHAR               3 WIN1252
TECHNIKER4                      VARCHAR               3 WIN1252
TECHNANZAHL1                    FLOAT                 4 <null>
TECHNANZAHL2                    FLOAT                 4 <null>
TECHNANZAHL3                    FLOAT                 4 <null>
TECHNANZAHL4                    FLOAT                 4 <null>
PREISTABELLE                    INTEGER               4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTEPG_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
BELNR                           VARCHAR               8 WIN1252
RECHNUNGSNUMMER                 INT64                 8 <null>
ZEILENNUMMER                    INTEGER               4 <null>
KUNDENNUMMER                    INTEGER               4 <null>
STATUS                          VARCHAR               2 WIN1252
DATUM                           DATE                  4 <null>
BEZEICHNUNG                     VARCHAR              60 WIN1252
MENGE                           FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTEPR_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
TABELLE                         INTEGER               4 <null>
RECHNUNGSNUMMER                 INT64                 8 <null>
KUNDENNUMMER                    INTEGER               4 <null>
STATUS                          VARCHAR               2 WIN1252
DATUM                           DATE                  4 <null>
AUFTRAGSNUMMER                  INT64                 8 <null>
ANREDE                          VARCHAR              30 WIN1252
VORNAME                         VARCHAR              30 WIN1252
NACHNAME                        VARCHAR              30 WIN1252
OKUK                            VARCHAR               2 WIN1252
ARBLEISTUNG                     FLOAT                 4 <null>
MATERIAL                        FLOAT                 4 <null>
MWSTARBLEISTUNG                 FLOAT                 4 <null>
MWSTMATERIAL                    FLOAT                 4 <null>
SAMMELRECHNR                    INT64                 8 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
XMLERGAENZUNG                   VARCHAR              51 WIN1252
HERSTELLUNGSORT                 VARCHAR              50 WIN1252
ABRECHNUNGSBEREICH              VARCHAR               5 WIN1252
XMLVERSION                      INTEGER               4 <null>


SOHOTESK_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
TABELLE                         INTEGER               4 <null>
ZEITRAUM                        VARCHAR               4 WIN1252
KUNDENNUMMER                    INTEGER               4 <null>
BELNR                           VARCHAR               8 WIN1252
MATERIALJAHRESWERT              FLOAT                 4 <null>
LEISTUNGJAHRESWERT              FLOAT                 4 <null>
MATERIALJANUAR                  FLOAT                 4 <null>
LEISTUNGJANUAR                  FLOAT                 4 <null>
MATERIALFEBRUAR                 FLOAT                 4 <null>
LEISTUNGFEBRUAR                 FLOAT                 4 <null>
MATERIALMAERZ                   FLOAT                 4 <null>
LEISTUNGMAERZ                   FLOAT                 4 <null>
MATERIALAPRIL                   FLOAT                 4 <null>
LEISTUNGAPRIL                   FLOAT                 4 <null>
MATERIALMAI                     FLOAT                 4 <null>
LEISTUNGMAI                     FLOAT                 4 <null>
MATERIALJUNI                    FLOAT                 4 <null>
LEISTUNGJUNI                    FLOAT                 4 <null>
MATERIALJULI                    FLOAT                 4 <null>
LEISTUNGJULI                    FLOAT                 4 <null>
MATERIALAUGUST                  FLOAT                 4 <null>
LEISTUNGAUGUST                  FLOAT                 4 <null>
MATERIALSEPTEMBER               FLOAT                 4 <null>
LEISTUNGSEPTEMBER               FLOAT                 4 <null>
MATERIALOKTOBER                 FLOAT                 4 <null>
LEISTUNGOKTOBER                 FLOAT                 4 <null>
MATERIALNOVEMBER                FLOAT                 4 <null>
LEISTUNGNOVEMBER                FLOAT                 4 <null>
MATERIALDEZEMBER                FLOAT                 4 <null>
LEISTUNGDEZEMBER                FLOAT                 4 <null>
ZEITJAHRESWERT                  INTEGER               4 <null>
ZEITJANUAR                      INTEGER               4 <null>
ZEITFEBRUAR                     INTEGER               4 <null>
ZEITMAERZ                       INTEGER               4 <null>
ZEITAPRIL                       INTEGER               4 <null>
ZEITMAI                         INTEGER               4 <null>
ZEITJUNI                        INTEGER               4 <null>
ZEITJULI                        INTEGER               4 <null>
ZEITAUGUST                      INTEGER               4 <null>
ZEITSEPTEMBER                   INTEGER               4 <null>
ZEITOKTOBER                     INTEGER               4 <null>
ZEITNOVEMBER                    INTEGER               4 <null>
ZEITDEZEMBER                    INTEGER               4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTEST_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
TABELLE                         INTEGER               4 <null>
ZEITRAUM                        VARCHAR               4 WIN1252
BELNR                           VARCHAR               8 WIN1252
GESAMTANZAHL                    FLOAT                 4 <null>
GESAMTPREIS                     FLOAT                 4 <null>
GESAMTZEIT                      FLOAT                 4 <null>
TECH1ANZAHL                     FLOAT                 4 <null>
TECH1PREIS                      FLOAT                 4 <null>
TECH1ZEIT                       FLOAT                 4 <null>
TECH2ANZAHL                     FLOAT                 4 <null>
TECH2PREIS                      FLOAT                 4 <null>
TECH2ZEIT                       FLOAT                 4 <null>
TECH3ANZAHL                     FLOAT                 4 <null>
TECH3PREIS                      FLOAT                 4 <null>
TECH3ZEIT                       FLOAT                 4 <null>
TECH4ANZAHL                     FLOAT                 4 <null>
TECH4PREIS                      FLOAT                 4 <null>
TECH4ZEIT                       FLOAT                 4 <null>
TECH5ANZAHL                     FLOAT                 4 <null>
TECH5PREIS                      FLOAT                 4 <null>
TECH5ZEIT                       FLOAT                 4 <null>
TECH6ANZAHL                     FLOAT                 4 <null>
TECH6PREIS                      FLOAT                 4 <null>
TECH6ZEIT                       FLOAT                 4 <null>
TECH7ANZAHL                     FLOAT                 4 <null>
TECH7PREIS                      FLOAT                 4 <null>
TECH7ZEIT                       FLOAT                 4 <null>
TECH8ANZAHL                     FLOAT                 4 <null>
TECH8PREIS                      FLOAT                 4 <null>
TECH8ZEIT                       FLOAT                 4 <null>
TECH9ANZAHL                     FLOAT                 4 <null>
TECH9PREIS                      FLOAT                 4 <null>
TECH9ZEIT                       FLOAT                 4 <null>
TECH10ANZAHL                    FLOAT                 4 <null>
TECH10PREIS                     FLOAT                 4 <null>
TECH10ZEIT                      FLOAT                 4 <null>
TECH11ANZAHL                    FLOAT                 4 <null>
TECH11PREIS                     FLOAT                 4 <null>
TECH11ZEIT                      FLOAT                 4 <null>
TECH12ANZAHL                    FLOAT                 4 <null>
TECH12PREIS                     FLOAT                 4 <null>
TECH12ZEIT                      FLOAT                 4 <null>
TECH13ANZAHL                    FLOAT                 4 <null>
TECH13PREIS                     FLOAT                 4 <null>
TECH13ZEIT                      FLOAT                 4 <null>
TECH14ANZAHL                    FLOAT                 4 <null>
TECH14PREIS                     FLOAT                 4 <null>
TECH14ZEIT                      FLOAT                 4 <null>
TECH15ANZAHL                    FLOAT                 4 <null>
TECH15PREIS                     FLOAT                 4 <null>
TECH15ZEIT                      FLOAT                 4 <null>
TECH16ANZAHL                    FLOAT                 4 <null>
TECH16PREIS                     FLOAT                 4 <null>
TECH16ZEIT                      FLOAT                 4 <null>
TECH17ANZAHL                    FLOAT                 4 <null>
TECH17PREIS                     FLOAT                 4 <null>
TECH17ZEIT                      FLOAT                 4 <null>
TECH18ANZAHL                    FLOAT                 4 <null>
TECH18PREIS                     FLOAT                 4 <null>
TECH18ZEIT                      FLOAT                 4 <null>
TECH19ANZAHL                    FLOAT                 4 <null>
TECH19PREIS                     FLOAT                 4 <null>
TECH19ZEIT                      FLOAT                 4 <null>
TECH20ANZAHL                    FLOAT                 4 <null>
TECH20PREIS                     FLOAT                 4 <null>
TECH20ZEIT                      FLOAT                 4 <null>
TECH21ANZAHL                    FLOAT                 4 <null>
TECH21PREIS                     FLOAT                 4 <null>
TECH21ZEIT                      FLOAT                 4 <null>
TECH22ANZAHL                    FLOAT                 4 <null>
TECH22PREIS                     FLOAT                 4 <null>
TECH22ZEIT                      FLOAT                 4 <null>
TECH23ANZAHL                    FLOAT                 4 <null>
TECH23PREIS                     FLOAT                 4 <null>
TECH23ZEIT                      FLOAT                 4 <null>
TECH24ANZAHL                    FLOAT                 4 <null>
TECH24PREIS                     FLOAT                 4 <null>
TECH24ZEIT                      FLOAT                 4 <null>
TECH25ANZAHL                    FLOAT                 4 <null>
TECH25PREIS                     FLOAT                 4 <null>
TECH25ZEIT                      FLOAT                 4 <null>
TECH26ANZAHL                    FLOAT                 4 <null>
TECH26PREIS                     FLOAT                 4 <null>
TECH26ZEIT                      FLOAT                 4 <null>
TECH27ANZAHL                    FLOAT                 4 <null>
TECH27PREIS                     FLOAT                 4 <null>
TECH27ZEIT                      FLOAT                 4 <null>
TECH28ANZAHL                    FLOAT                 4 <null>
TECH28PREIS                     FLOAT                 4 <null>
TECH28ZEIT                      FLOAT                 4 <null>
TECH29ANZAHL                    FLOAT                 4 <null>
TECH29PREIS                     FLOAT                 4 <null>
TECH29ZEIT                      FLOAT                 4 <null>
TECH30ANZAHL                    FLOAT                 4 <null>
TECH30PREIS                     FLOAT                 4 <null>
TECH30ZEIT                      FLOAT                 4 <null>
TECH31ANZAHL                    FLOAT                 4 <null>
TECH31PREIS                     FLOAT                 4 <null>
TECH31ZEIT                      FLOAT                 4 <null>
TECH32ANZAHL                    FLOAT                 4 <null>
TECH32PREIS                     FLOAT                 4 <null>
TECH32ZEIT                      FLOAT                 4 <null>
TECH33ANZAHL                    FLOAT                 4 <null>
TECH33PREIS                     FLOAT                 4 <null>
TECH33ZEIT                      FLOAT                 4 <null>
TECH34ANZAHL                    FLOAT                 4 <null>
TECH34PREIS                     FLOAT                 4 <null>
TECH34ZEIT                      FLOAT                 4 <null>
TECH35ANZAHL                    FLOAT                 4 <null>
TECH35PREIS                     FLOAT                 4 <null>
TECH35ZEIT                      FLOAT                 4 <null>
TECH36ANZAHL                    FLOAT                 4 <null>
TECH36PREIS                     FLOAT                 4 <null>
TECH36ZEIT                      FLOAT                 4 <null>
TECH37ANZAHL                    FLOAT                 4 <null>
TECH37PREIS                     FLOAT                 4 <null>
TECH37ZEIT                      FLOAT                 4 <null>
TECH38ANZAHL                    FLOAT                 4 <null>
TECH38PREIS                     FLOAT                 4 <null>
TECH38ZEIT                      FLOAT                 4 <null>
TECH39ANZAHL                    FLOAT                 4 <null>
TECH39PREIS                     FLOAT                 4 <null>
TECH39ZEIT                      FLOAT                 4 <null>
TECH40ANZAHL                    FLOAT                 4 <null>
TECH40PREIS                     FLOAT                 4 <null>
TECH40ZEIT                      FLOAT                 4 <null>
TECH41ANZAHL                    FLOAT                 4 <null>
TECH41PREIS                     FLOAT                 4 <null>
TECH41ZEIT                      FLOAT                 4 <null>
TECH42ANZAHL                    FLOAT                 4 <null>
TECH42PREIS                     FLOAT                 4 <null>
TECH42ZEIT                      FLOAT                 4 <null>
TECH43ANZAHL                    FLOAT                 4 <null>
TECH43PREIS                     FLOAT                 4 <null>
TECH43ZEIT                      FLOAT                 4 <null>
TECH44ANZAHL                    FLOAT                 4 <null>
TECH44PREIS                     FLOAT                 4 <null>
TECH44ZEIT                      FLOAT                 4 <null>
TECH45ANZAHL                    FLOAT                 4 <null>
TECH45PREIS                     FLOAT                 4 <null>
TECH45ZEIT                      FLOAT                 4 <null>
TECH46ANZAHL                    FLOAT                 4 <null>
TECH46PREIS                     FLOAT                 4 <null>
TECH46ZEIT                      FLOAT                 4 <null>
TECH47ANZAHL                    FLOAT                 4 <null>
TECH47PREIS                     FLOAT                 4 <null>
TECH47ZEIT                      FLOAT                 4 <null>
TECH48ANZAHL                    FLOAT                 4 <null>
TECH48PREIS                     FLOAT                 4 <null>
TECH48ZEIT                      FLOAT                 4 <null>
TECH49ANZAHL                    FLOAT                 4 <null>
TECH49PREIS                     FLOAT                 4 <null>
TECH49ZEIT                      FLOAT                 4 <null>
TECH50ANZAHL                    FLOAT                 4 <null>
TECH50PREIS                     FLOAT                 4 <null>
TECH50ZEIT                      FLOAT                 4 <null>
TECH51ANZAHL                    FLOAT                 4 <null>
TECH51PREIS                     FLOAT                 4 <null>
TECH51ZEIT                      FLOAT                 4 <null>
TECH52ANZAHL                    FLOAT                 4 <null>
TECH52PREIS                     FLOAT                 4 <null>
TECH52ZEIT                      FLOAT                 4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>


SOHOTETX_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
TABELLE                         INTEGER               4 <null>
PLZNR                           VARCHAR               8 WIN1252
PLZNRERGAENZUNG                 VARCHAR               3 WIN1252
ERLAEUTERUNG1                   VARCHAR             255 WIN1252
ERLAEUTERUNG2                   VARCHAR             255 WIN1252
ERLAEUTERUNG3                   VARCHAR             255 WIN1252
BERECHHINWEIS1                  VARCHAR             255 WIN1252
BERECHHINWEIS2                  VARCHAR             255 WIN1252
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
ERLAEUTERUNG4                   VARCHAR             255 WIN1252
ERLAEUTERUNG5                   VARCHAR             255 WIN1252
ERLAEUTERUNG6                   VARCHAR             255 WIN1252
BERECHHINWEIS3                  VARCHAR             255 WIN1252
BERECHHINWEIS4                  VARCHAR             255 WIN1252
BERECHHINWEIS5                  VARCHAR             255 WIN1252
BERECHHINWEIS6                  VARCHAR             255 WIN1252


SOHOZAHN_FIELD_NAME             FIELD_TYPE FIELD_LENGTH FIELD_CHARSET
=============================== ========== ============ ===============================
SATZNR                          INTEGER               4 <null>
A000                            INTEGER               4 <null>
A001                            INTEGER               4 <null>
A002                            INTEGER               4 <null>
A003                            INTEGER               4 <null>
A004                            INTEGER               4 <null>
A005                            INTEGER               4 <null>
A006                            INTEGER               4 <null>
A007                            INTEGER               4 <null>
A008                            INTEGER               4 <null>
A009                            INTEGER               4 <null>
A010                            INTEGER               4 <null>
A011                            INTEGER               4 <null>
A012                            INTEGER               4 <null>
A013                            INTEGER               4 <null>
A014                            INTEGER               4 <null>
A015                            INTEGER               4 <null>
A016                            INTEGER               4 <null>
A017                            INTEGER               4 <null>
A018                            INTEGER               4 <null>
A019                            INTEGER               4 <null>
A020                            INTEGER               4 <null>
A021                            INTEGER               4 <null>
A022                            INTEGER               4 <null>
A023                            INTEGER               4 <null>
A024                            INTEGER               4 <null>
A025                            INTEGER               4 <null>
A026                            INTEGER               4 <null>
A027                            INTEGER               4 <null>
A028                            INTEGER               4 <null>
A029                            INTEGER               4 <null>
A030                            INTEGER               4 <null>
A031                            INTEGER               4 <null>
A032                            INTEGER               4 <null>
A033                            INTEGER               4 <null>
A034                            INTEGER               4 <null>
A035                            INTEGER               4 <null>
A036                            INTEGER               4 <null>
A037                            INTEGER               4 <null>
A038                            INTEGER               4 <null>
A039                            INTEGER               4 <null>
A040                            INTEGER               4 <null>
A041                            INTEGER               4 <null>
A042                            INTEGER               4 <null>
A043                            INTEGER               4 <null>
A044                            INTEGER               4 <null>
A045                            INTEGER               4 <null>
A046                            INTEGER               4 <null>
A047                            INTEGER               4 <null>
A048                            INTEGER               4 <null>
A049                            INTEGER               4 <null>
A050                            INTEGER               4 <null>
A051                            INTEGER               4 <null>
A052                            INTEGER               4 <null>
A053                            INTEGER               4 <null>
A054                            INTEGER               4 <null>
A055                            INTEGER               4 <null>
A056                            INTEGER               4 <null>
A057                            INTEGER               4 <null>
A058                            INTEGER               4 <null>
A059                            INTEGER               4 <null>
A060                            INTEGER               4 <null>
A061                            INTEGER               4 <null>
A062                            INTEGER               4 <null>
A063                            INTEGER               4 <null>
A064                            INTEGER               4 <null>
A065                            INTEGER               4 <null>
A066                            INTEGER               4 <null>
A067                            INTEGER               4 <null>
A068                            INTEGER               4 <null>
A069                            INTEGER               4 <null>
A070                            INTEGER               4 <null>
A071                            INTEGER               4 <null>
A072                            INTEGER               4 <null>
A073                            INTEGER               4 <null>
A074                            INTEGER               4 <null>
A075                            INTEGER               4 <null>
A076                            INTEGER               4 <null>
A077                            INTEGER               4 <null>
A078                            INTEGER               4 <null>
A079                            INTEGER               4 <null>
A080                            INTEGER               4 <null>
A081                            INTEGER               4 <null>
A082                            INTEGER               4 <null>
A083                            INTEGER               4 <null>
A084                            INTEGER               4 <null>
A085                            INTEGER               4 <null>
A086                            INTEGER               4 <null>
A087                            INTEGER               4 <null>
A088                            INTEGER               4 <null>
A089                            INTEGER               4 <null>
A090                            INTEGER               4 <null>
A091                            INTEGER               4 <null>
A092                            INTEGER               4 <null>
A093                            INTEGER               4 <null>
A094                            INTEGER               4 <null>
A095                            INTEGER               4 <null>
A096                            INTEGER               4 <null>
A097                            INTEGER               4 <null>
A098                            INTEGER               4 <null>
A099                            INTEGER               4 <null>
A100                            INTEGER               4 <null>
A101                            INTEGER               4 <null>
A102                            INTEGER               4 <null>
A103                            INTEGER               4 <null>
A104                            INTEGER               4 <null>
A105                            INTEGER               4 <null>
A106                            INTEGER               4 <null>
A107                            INTEGER               4 <null>
A108                            INTEGER               4 <null>
A109                            INTEGER               4 <null>
A110                            INTEGER               4 <null>
A111                            INTEGER               4 <null>
A112                            INTEGER               4 <null>
A113                            INTEGER               4 <null>
A114                            INTEGER               4 <null>
A115                            INTEGER               4 <null>
A116                            INTEGER               4 <null>
A117                            INTEGER               4 <null>
A118                            INTEGER               4 <null>
A119                            INTEGER               4 <null>
A120                            INTEGER               4 <null>
A121                            INTEGER               4 <null>
A122                            INTEGER               4 <null>
A123                            INTEGER               4 <null>
A124                            INTEGER               4 <null>
A125                            INTEGER               4 <null>
A126                            INTEGER               4 <null>
A127                            INTEGER               4 <null>
A128                            INTEGER               4 <null>
A129                            INTEGER               4 <null>
A130                            INTEGER               4 <null>
A131                            INTEGER               4 <null>
A132                            INTEGER               4 <null>
A133                            INTEGER               4 <null>
A134                            INTEGER               4 <null>
A135                            INTEGER               4 <null>
A136                            INTEGER               4 <null>
A137                            INTEGER               4 <null>
A138                            INTEGER               4 <null>
A139                            INTEGER               4 <null>
A140                            INTEGER               4 <null>
A141                            INTEGER               4 <null>
A142                            INTEGER               4 <null>
A143                            INTEGER               4 <null>
A144                            INTEGER               4 <null>
A145                            INTEGER               4 <null>
A146                            INTEGER               4 <null>
A147                            INTEGER               4 <null>
A148                            INTEGER               4 <null>
A149                            INTEGER               4 <null>
A150                            INTEGER               4 <null>
A151                            INTEGER               4 <null>
A152                            INTEGER               4 <null>
A153                            INTEGER               4 <null>
A154                            INTEGER               4 <null>
A155                            INTEGER               4 <null>
A156                            INTEGER               4 <null>
A157                            INTEGER               4 <null>
A158                            INTEGER               4 <null>
A159                            INTEGER               4 <null>
A160                            INTEGER               4 <null>
A161                            INTEGER               4 <null>
A162                            INTEGER               4 <null>
A163                            INTEGER               4 <null>
A164                            INTEGER               4 <null>
A165                            INTEGER               4 <null>
A166                            INTEGER               4 <null>
A167                            INTEGER               4 <null>
A168                            INTEGER               4 <null>
A169                            INTEGER               4 <null>
A170                            INTEGER               4 <null>
A171                            INTEGER               4 <null>
A172                            INTEGER               4 <null>
A173                            INTEGER               4 <null>
A174                            INTEGER               4 <null>
A175                            INTEGER               4 <null>
GEAENDERTMOD                    INTEGER               4 <null>
GEAENDERTAMDAT                  DATE                  4 <null>
GEAENDERTAMZEIT                 TIME                  4 <null>
GEAENDERTVON                    VARCHAR              30 WIN1252
VERSION_NR                      INTEGER               4 <null>
```

Es gibt zwar keinen direkten Export in CSV-Dateien oder ähnlichem, dafür kann aber CSV-Dateien über einen Trick erstellen. In ISQL geht dies so:
```
output 'C:\temp\BelBebNr.csv'
select '"' || Trim(belNr) || '";"' || Trim(belnrausdruck) || '";"' || Trim(Bezeichnung) || '"' from SOHOTEAR order by belnr;
output;
```

Danach kann man die CSV-Datei wie gewohnt in Powershell einlesen:
```
PS C:\temp> $csv=Import-Csv -Path .\BelBebNr.csv -Header @('BelNr', 'Ausdruck', 'Bezeichnung') -Delimiter ';'
PS C:\temp> $csv|select -First 3

BelNr Ausdruck Bezeichnung
----- -------- -----------
1
-1             Oberkiefer
-1             Oberkiefer
```
        
Aber wie immer gibts Probleme mit den Umlauten. Wahrscheinlich wirds auch noch mit dem einen oder anderen Feldtypen Probleme geben...
TODO...


Auf jeden Fall ist nun klar für was das Feld Tabellen steht, darunter werden die Leistungsverzeichnisse verstanden, also BEBART im Delapro. Die BelNr ist die Nummer einer Leistung oder eines Materials, wobei es eine Besonderheit gibt, denn es gehört das Feld BelNrErweiterung dazu. Im Grunde gilt BelNr+BelNrErweiterung = BELNR im Delapro. Die Leistungen und Materialien sind in der Tabelle SOHOTEAR untergebracht, enstpricht also ARTIKEL.DBF im Delapro.
Im Feld Tabellen stehen die Werte 0=BEB, 1=BEL2, 2=Material, 3=BEBZ. Da das Feld 4stellig ist, gäbs noch jede Menge weitere, aber mehr sind momentan nicht bekannt. Auch scheint es keine Tabelle mit einer Namendefinition für die Verzeichnisse zu geben.

```Powershell
# aus Tabelle mit Feldnamen Liste für CSV-Export erstellen
$Felder = @"
TABELLE            
BELNR              
BELNRERWEITERUNG   
BEZEICHNUNG        
EINZELPREIS        
RUESTZEIT          
VERWEILZEIT        
BEARBZEIT          
ZUSEINGABEVONBIS   
ZUSEINGABE2VONBIS  
ZUSEINGABE3VONBIS  
RVOEXTRA           
BELNRAUSDRUCK      
ABWABTEILUNG       
MATERIALART        
HERSTELLER         
BESTANDTEIL        
SONSTIGES          
ZUSCHLPLANZ1       
ZUSCHLPLANZ2       
ZUSCHLPLANZ3       
KSTUNDENSATZ       
KRUESTZEIT         
ZUSCHLKUND1        
ZUSCHLKUND2        
ZUSCHLKUND3        
ZUSCHLKUND4        
KSKPREIS           
GEAENDERTMOD       
GEAENDERTAMDAT     
GEAENDERTAMZEIT    
GEAENDERTVON       
VERSION_NR         
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
$output = $Felder|%{$_.Trim()}|%{$CSVBegin}{"$_ $($CSVSeparator)"}{$CSVEnd}
"Select $Output FROM SOHOTEAR WHERE Tabelle = 0 ORDER BY BELNR;"
```

Export der BEB-Leistungen, Reihenfolge WHERE und ORDER BY beachten!
```

output 'C:\temp\BebLeistungen.csv'
select '"' || Trim(belNr) || '";"' || Trim(belnrausdruck) || '";"' || Trim(Bezeichnung) || '"' from SOHOTEAR WHERE Tabelle = 0 order by belnr ;
output;
```
