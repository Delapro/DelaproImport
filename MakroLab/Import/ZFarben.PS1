# ZFARBEN sind die Zahnfarben hinterlegt

	$Zahnfarben = Invoke-SqlCmd -Query "SELECT * FROM ZFarben" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	

$Zahnfarben | select -Property Farbe | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Zahnfarb.CSV -Force @Encoding -Verbose