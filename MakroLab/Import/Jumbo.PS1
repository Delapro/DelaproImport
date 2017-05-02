# JUMBO Jumbokopfdatei
#	Folgenummerprüfung:  where folgenummer -isnot [System.DBNull] | where {$_.folgenummer.Trim().length -gt 0 }
#	erst jetzt hat man die Menge an Jumbos, wo Folgenummern haben
	
	$j = Invoke-SqlCmd -Query "SELECT * FROM Jumbo" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
	$JumboFelder = @(
		@{Name="Name";Expression={$_.Nummer}},
		@{Name="Nummer";Expression={$global:JNr++; $global:JNrLink+=@{$_.Nummer=$global:JNr}; $global:JNr }},
		"Bezeichnung",
		@{Name="SofortEins";Expression={"J"}},
		@{Name="Markiert";Expression={""}},
		@{Name="AbrechArt";Expression={"L"}},
		@{Name="Zahnschema";Expression={"F"}}
	)
	
	$global:JNr=1000
	$global:JNrLink=@{}
	
	$j | select -Property $JumboFelder| ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\StueckL2.CSV -Force @Encoding -Verbose
	
	
If ($Modus -eq [MLVariante]::Paradox) {
    ren $expPath\StueckL2.CSV $expPath\StueckL2.TXT
    Invoke-Umlaute -CsvFile $expPath\StueckL2.TXT -DestFile $expPath\StueckL2.CSV
}
