# Firebird 3 oder 4?

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
