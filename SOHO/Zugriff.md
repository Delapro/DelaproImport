# Zugriff auf die Daten

## per iSQL.exe

## per Powershell

Firebird Server manuell starten

```Powershell
PS C:\Program Files\Firebird\Firebird_3_0>.\firebird.exe -a
# Firebird manuell stoppen, ist quasi offiziell
Stop-Process -Name firebird
```

es bleibt zwar das Symbol noch in der Systray aber er läuft nicht mehr

Zugriff über ISQL.EXE mit übergabe von user und password
SQL> connect c:\temp\sohotech.fdb user sysdba password easy1;

==> Nachfolgendes alles mit Adminrechten ausgeführt!!

```Powershell
PS C:\Users\admin> Install-Module -Name InvokeQuery
PS C:\Users\admin> $query =New-SqlQuery -Sql 'SELECT COUNT(*) FROM SOHOTEAR'
PS C:\Users\admin> Invoke-FirebirdQuery -SqlQuery $query -Database C:\temp\SOHOTECH.FDB -Credential $cred -Verbose
AUSFÜHRLICH: Using the following connection string: Data Source=localhost;Initial Catalog=C:\temp\SOHOTECH.FDB;User
ID=sysdba;Password=xxxxxxxxxx;
AUSFÜHRLICH: Opening connection.
AUSFÜHRLICH: Processed 0 queries in 10 milliseconds.
AUSFÜHRLICH: Complete.
Invoke-FirebirdQuery : Incompatible wire encryption levels requested on client and server
In Zeile:1 Zeichen:1
+ Invoke-FirebirdQuery -SqlQuery $query -Database C:\temp\SOHOTECH.FDB  ...
```

danach

```Powershell
PS C:\Program Files\Firebird\Firebird_3_0> notepad .\firebird.conf
```

Bei

```Powershell
#
# Should connection over the wire be encrypted?
# Has 3 different values: Required, Enabled or Disabled. Enabled behavior
# depends on the other side's requirements. If both sides are set to Enabled,
# the connection is encrypted when possible. Note that Wirecrypt should be set 
# to Enabled when running a Firebird server with legacy authentication.
#
# Attention: default depends upon connection type: incoming (server)
#            or outgoing (client).
#
# Per-connection configurable.
#
# Type: string (predefined values)
#
#WireCrypt = Enabled (for client) / Required (for server)
WireCrypt=Enabled
```

WireCrypt=Enabled hinzugefügt, bzw. gesetzt.


Dann klappte es aber immer noch nicht:

```Powershell
PS C:\Program Files\Firebird\Firebird_3_0> Invoke-FirebirdQuery -SqlQuery $query -Database C:\temp\SOHOTECH.FDB -Credential $cred -Verbose                                                                                                      AUSFÜHRLICH: Using the following connection string: Data Source=localhost;Initial Catalog=C:\temp\SOHOTECH.FDB;User     ID=sysdba;Password=xxxxxxxxxx;                                                                                          AUSFÜHRLICH: Opening connection.                                                                                        AUSFÜHRLICH: Processed 0 queries in 129 milliseconds.                                                                   AUSFÜHRLICH: Complete.                                                                                                  Invoke-FirebirdQuery : Error occurred during login, please check server firebird.log for details                        In Zeile:1 Zeichen:1                                                                                                    + Invoke-FirebirdQuery -SqlQuery $query -Database C:\temp\SOHOTECH.FDB  ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Invoke-FirebirdQuery], FbException
    + FullyQualifiedErrorId : FirebirdSql.Data.FirebirdClient.FbException,InvokeQuery.InvokeFirebirdQuery

```


Danach war einmal eine erfolgreiche Abfrage möglich:
```Powershell
PS C:\Program Files\Firebird\Firebird_3_0> .\firebird.exe -a
PS C:\Program Files\Firebird\Firebird_3_0> Invoke-FirebirdQuery -SqlQuery $query -Database C:\temp\SOHOTECH.FDB -Credential $cred -Verbose
AUSFÜHRLICH: Using the following connection string: Data Source=localhost;Initial Catalog=C:\temp\SOHOTECH.FDB;User
ID=sysdba;Password=xxxxxxxxxx;
AUSFÜHRLICH: Opening connection.
AUSFÜHRLICH: Connection to database is open.
AUSFÜHRLICH: Running query number 1
AUSFÜHRLICH: Running the following query: SELECT COUNT(*) FROM SOHOTEAR
AUSFÜHRLICH: Ausführen des Vorgangs "Run Query:`SELECT COUNT(*) FROM SOHOTEAR`" für das Ziel "Database server".
AUSFÜHRLICH: Query returned 1 rows.

AUSFÜHRLICH: Closing connection.
AUSFÜHRLICH: Processed 1 queries in 566 milliseconds.
AUSFÜHRLICH: Complete.
COUNT
-----
2278
```

Dann wurde Firebird nochmal beendet, es meldete noch eine offene Connection, Meldung wurde weggeklickt und Firebird trotzdem beendet. Obwohl Firebird nochmal neu gestartet wurde, klappen nun die Anfragen nicht mehr:

```Powershell
PS C:\Program Files\Firebird\Firebird_3_0> Invoke-FirebirdQuery -Sql "select COUNT(*) FROM SOHOTEAR" -Database C:\temp\SOHOTECH.FDB -Credential $cred -Verbose                                                                                  AUSFÜHRLICH: Using the following connection string: Data Source=localhost;Initial Catalog=C:\temp\SOHOTECH.FDB;User     ID=sysdba;Password=xxxxxxxxxx;                                                                                          AUSFÜHRLICH: Opening connection.                                                                                        AUSFÜHRLICH: Connection to database is open.                                                                            AUSFÜHRLICH: Running query number 1                                                                                     AUSFÜHRLICH: Running the following query: select COUNT(*) FROM SOHOTEAR
AUSFÜHRLICH: Ausführen des Vorgangs "Run Query:`select COUNT(*) FROM SOHOTEAR`" für das Ziel "Database server".
AUSFÜHRLICH: Closing connection.
AUSFÜHRLICH: Processed 1 queries in 74 milliseconds.
AUSFÜHRLICH: Complete.
Invoke-FirebirdQuery : Error reading data from the connection.
In Zeile:1 Zeichen:1
+ Invoke-FirebirdQuery -Sql "select COUNT(*) FROM SOHOTEAR" -Database C ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Invoke-FirebirdQuery], FbException
    + FullyQualifiedErrorId : FirebirdSql.Data.FirebirdClient.FbException,InvokeQuery.InvokeFirebirdQuery
```                                                                                        


Eine weitere Fehlermeldung wenn $cred nicht definiert ist:

```Powershell
PS C:\Program Files\Firebird\Firebird_3_0> Invoke-FirebirdQuery -Sql "select COUNT(*) FROM SOHOTEAR" -Database C:\temp\SOHOTECH.FDB -Credential $cred -Verbose
AUSFÜHRLICH: Processed 0 queries in 0 milliseconds.
AUSFÜHRLICH: Complete.
Invoke-FirebirdQuery : Der Objektverweis wurde nicht auf eine Objektinstanz festgelegt.
In Zeile:1 Zeichen:1                                                                                                    + Invoke-FirebirdQuery -Sql "select COUNT(*) FROM SOHOTEAR" -Database C ...                     
```

Aber obige Probleme ließen sich umgehen, nachdem eine neue Eingabeaufforderung mit Adminrechten gestartet wurde!


Das ist nun die Variante wie es immer klappt:
```Powershell
cd 'C:\Program Files\Firebird\Firebird_3_0'
$pw=ConvertTo-SecureString -Force -AsPlainText 'easy1'
$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'sysdba', $pw
.\firebird.exe -a
Invoke-FirebirdQuery -Sql "select COUNT(*) FROM SOHOTEAR" -Database C:\temp\SOHOTECH.FDB -Credential $cred
```
