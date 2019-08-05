# Hilfsroutinen um eine SQL-Datenbank analysieren zu können

# $sm sollte definiert sein, z. B. so:
# Name der SQL-Server-Instanz
$SQLInstanz = '.\SQLEXPRESS'

$location = Get-Location
Import-Module sqlps -DisableNameChecking
Set-Location -Path $location
$sm = New-Object Microsoft.SqlServer.Management.Smo.Server $SQLInstanz


Function Get-Table {
	Param($table) Invoke-SqlCmd -Query "SELECT * FROM $table" -Database $global:sm.Databases[0].Name -Serverinstance $global:sm.DomainInstanceName
}

Function Show-Table {
	Param($table) Get-Table $table | Out-GridView -Title $table
}

# vergleicht den Inhalt zweier Spalten in einer Tabelle, ob diese immer identisch sind
Function Compare-TableColumns {
	Param ($table, $column1, $column2)
	Invoke-SqlCmd -Query "SELECT $column1 , $column FROM $table WHERE  $column1 <> $column2" -Database $global:sm.Databases[0].Name -Serverinstance $global:sm.DomainInstanceName
}

# gibt die Felder einer Tabelle aus
Function Show-TableStructure {
	Param ($table)
	$global:sm.Databases[0].Tables[$table].Columns|Select-Object id, name, datatype, @{N="Length";E={$_.properties| Where-Object {$_.Name -eq 'Length'} | Select-Object -ExpandProperty value  }}
}

# gibt alle Tabellen einer Datenbank aus, inkl. der Anzahl der vorhandenen Datensätze und Indizes pro Tabelle
Function Show-TableOverview {
$global:sm.Databases[0].Tables| Select-Object schema, name, datelastmodified, @{N="Records";E={(Invoke-SqlCmd -Query "SELECT COUNT(*) AS Anzahl FROM $_" -Database $global:sm.Databases[0].Name -Serverinstance $global:sm.DomainInstanceName ).Anzahl}}, indexes
}

# sucht alle Feldnamen die den übergebenen Wert $Name enthalten, zeigt dazu die zugehörigen Tabellen sowie den betreffenden Datentyp an
Function Show-Fields {
	Param($Name)
	$ipp=$Name; $sm.Databases[0].Tables | ForEach-Object {$_.Columns } | Where-Object {$_.Name -match $ipp } | Select-Object Name, Parent, Datatype, @{Name="Rows"; Expression={($_.Parent).RowCount}} | Format-Table * -autoSize
}

$MegaQuery=@"

CREATE PROC SearchAllTables
(
    @SearchStr nvarchar(100)
)
AS
BEGIN
CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))
SET NOCOUNT ON
DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
    SET  @TableName = ''
    SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
WHILE @TableName IS NOT NULL
BEGIN
        SET @ColumnName = ''
        SET @TableName = 
        (
            SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
            FROM     INFORMATION_SCHEMA.TABLES
            WHERE         TABLE_TYPE = 'BASE TABLE'
                AND    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
                AND    OBJECTPROPERTY(
                        OBJECT_ID(
                            QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                             ), 'IsMSShipped'
                               ) = 0
        )
WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
BEGIN
            SET @ColumnName =
            (
                SELECT MIN(QUOTENAME(COLUMN_NAME))
                FROM     INFORMATION_SCHEMA.COLUMNS
                WHERE         TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                    AND    TABLE_NAME    = PARSENAME(@TableName, 1)
                    AND    DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal')
                    AND    QUOTENAME(COLUMN_NAME) > @ColumnName
            )
IF @ColumnName IS NOT NULL
BEGIN
                INSERT INTO #Results
                EXEC
                (
                    'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
                    FROM ' + @TableName + ' (NOLOCK) ' +
                    ' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
                )
            END
        END    
    END
SELECT ColumnName, ColumnValue FROM #Results
END

"@

# MegaQuery zur freien Suche nach Inhalt in beliebigem Feld unabhängig von der Tabelle
# Stored Procedure anlegen:
Invoke-SqlCmd -Query $megaQuery -Serverinstance $sm.DomainInstanceName  -Database $sm.Databases[0].Name
# Bestimmten Wert abfragen, hier z. B. RITA:
$Ergebnis=Invoke-SqlCmd -Query "EXEC SearchAllTables 'RITA'"  -Serverinstance $sm.DomainInstanceName  -Database $sm.Databases[0].Name
$Ergebnis


# bei Querys kann es vorkommen, dass es bei JOINS mit SELECT * doppelte Spaltennamen gibt, dann erhält man diese Fehlermeldung:
#
# Invoke-SqlCmd : Doppelte Spaltennamen sind in SQL PowerShell nicht zulässig. Um eine Spalte zu wiederholen, verwenden Sie für die doppelte Spalte einen 
# Spaltenalias im Format 'Column_Name AS New_Name'.
# In C:\temp\HyperDentImport\Import\adressen.PS1:9 Zeichen:8
# + $adr = Invoke-SqlCmd -Query $Query -Database $sm.Databases[0].Name -S ...
# +        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : SyntaxError: (:) [Invoke-Sqlcmd], SqlPowerShellSqlExecutionException
#     + FullyQualifiedErrorId : DuplicateColumnNameErrorMessage,Microsoft.SqlServer.Management.PowerShell.GetScriptCommand
#
#
# um die doppelten Spaltennamen zu ermitteln, holt man sich einfach die Tabellenstruktur und vergleicht die Felder:
#
# PS > $sa=Show-TableStructure adressen                                       
# PS > $sk=Show-TableStructure adr_kunden                                     
# PS > Compare-Object $sa $sk -Property "Name" -IncludeEqual -ExcludeDifferent
#
# Name    SideIndicator
# ----    -------------
# adr_nr  ==
# status  ==
# berater ==
# flags1  ==
#
