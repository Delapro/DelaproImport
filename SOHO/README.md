# Notizen zu SOHO

Verwendet Firebird. https://firebirdsql.org/

Aktuell Version 4. 
Wenn installiert befinden sich Tools im Verzeichnis 'C:\Program Files\Firebird\Firebird_4_0'.
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

Um per Powershell auf Firebird-SQL-Server zugreifen zu können kann man InvokeQuery verwenden: https://www.powershellgallery.com/packages/InvokeQuery/1.0.2. Es bringt die Funktion <code>Invoke-FirebirdQuery</code> mit.

Beispiel: https://stackoverflow.com/questions/58501690/connection-to-firebird-from-powershell-script

Oder per ODBC: https://stackoverflow.com/questions/18704610/powershell-connect-to-firebird
