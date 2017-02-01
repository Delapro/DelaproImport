# Import aus Makrolab

## Einführung

Zum Import von Daten aus Makrolab muss man wissen, dass es verschiedene Varianten gibt. Es gibt einmal Dateien die mit einer paradoxähnlichen Datenbank namens [DBISAM V4](http://www.elevatesoft.com/products?category=dbisam) arbeiten. Die Netzwerkversion verwendet den Microsoft SQL-Server.

Das Verzeichnis mit den Daten von der einfachen Makrolabversion finden sich unter
```
C:\Datext\MakroLab\Daten\
```

Bei der "iLab Office SQL"-Variante findet sich die Datenbank unter 
```
C:\Datext\MSSQL10_50.DATEXTSQLE\MSSQL\DATA
```
Für den Zugang zum SQL-Server benötigt man noch ein Administratorpasswort:
```
User: sa
Password: I#d3K5l5d3W5
```

## Zugriff auf die Daten von Makrolab per Powershell mittels OLEDB

Mittels dieser Variante kann man alle *.DB-Dateien öffnen.

```Powershell
# Pfad der *.DB-Dateien
$Daten = "C:\Datext\MakroLab\Daten\"
# funktioniert nur unter 32-Bit
If (-Not ([System.IntPtr]::Size -eq 4) {
    Write-Error "Bitte Powershell als 32-Bit Prozess starten!"
}
$f=[System.Data.Common.DbProviderFactories]::GetFactory("System.Data.OleDB")
$con=$f.CreateConnection()
$con.ConnectionString="Provider=Microsoft.Jet.OLEDB.4.0; Data Source=$Daten; Extended Properties='Paradox 5.x';"
$con.Open()
$com=$con.CreateCommand()
$com.CommandText="SELECT * FROM AbtBez"
$dt=[System.Data.DataTable]::new()
$reader=$com.ExecuteReader()
$dt.Load($reader)
$dt|Out-GridView
$reader.Close()
$con.Close()
```

## Besonderheit wegen DBISAM4

Der Einsatz von DBISAM4 sorgt dafür, dass nicht mehr so einfach mittels OleDB auf die Daten zugegriffen werden kann. Ein Beispiel für die Verwendung von DBISAM4 ist die Datei BZEILEN.DAT. Um mit der BZEILEN.DAT etwas anfangen zu können wird eine ODBC-Verbindung benötigt. Falls man nur einmalig die Daten konvertieren muss, kann man auch das "Database System Utility" DBSYS.EXE von Elevate Software zum Exportieren der Daten als CSV-Datei verwenden.
