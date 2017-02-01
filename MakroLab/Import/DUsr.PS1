# DUSR enthält die Benutzer des Programms und deren Zugriffsrechte
# "SELECT [ID],[Benutzer],[Passwort],[Benutzername] FROM [DUSR]"

	$Benutzer = Invoke-SqlCmd -Query "SELECT * FROM DUSR" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
