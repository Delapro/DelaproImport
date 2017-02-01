# ReBu.PS1 importiert Monatsaufstellungen

	$Rech = Invoke-SqlCmd -Query "SELECT * FROM REBU" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
	$RechFelder = @(
		@{Name="Nummer";Expression={MoaNr $_.RechNummer}},
		@{Name="AuftragNr";Expression={""}},
		@{Name="Datum";Expression={Get-date $_.RechDatum -format "yyyyMMdd"}},
		@{Name="Ziel";Expression={Get-date $_.Faelligkeit -format "yyyyMMdd"}},
		@{Name="KunNummer";Expression={KunNr $_.Kundennummer}},
		@{Name="Zahlstatus";Expression={"B"}},
		@{Name="BezDat1";Expression={""}},
		@{Name="BezDat2";Expression={""}},
		@{Name="BezDat3";Expression={""}},
		@{Name="BezDat4";Expression={""}},
		@{Name="BezWie1";Expression={""}},
		@{Name="BezWie2";Expression={""}},
		@{Name="BezWie3";Expression={""}},
		@{Name="BezWie4";Expression={""}},
		@{Name="BezWer1";Expression={""}},
		@{Name="BezWer2";Expression={""}},
		@{Name="BezWer3";Expression={""}},
		@{Name="BezWer4";Expression={""}},
		@{Name="BezDM1";Expression={""}},
		@{Name="BezDM2";Expression={""}},
		@{Name="BezDM3";Expression={""}},
		@{Name="BezDM4";Expression={""}},
		@{Name="BezGesam";Expression={""}},
		@{Name="Status";Expression={""}},
		@{Name="Ziel1";Expression={""}},
		@{Name="Ziel2";Expression={""}},
		@{Name="Ziel3";Expression={""}},
		@{Name="Ziel4";Expression={""}},
		@{Name="SummeLeis";Expression={""}},
		@{Name="SummeEdel";Expression={""}},
		@{Name="SummeZaeh";Expression={""}},
		@{Name="SummeFert";Expression={""}},
		@{Name="SummeGesa";Expression={$_.BruttoGes}},
		@{Name="SMwStLeis";Expression={""}},
		@{Name="SMwStEdel";Expression={""}},
		@{Name="SMwStZaeh";Expression={""}},
		@{Name="SMwStFert";Expression={""}},
		@{Name="SMwStGesa";Expression={""}},
		@{Name="MwSt";Expression={""}},
		@{Name="SkontoZiel";Expression={""}},
		@{Name="Skonto";Expression={""}},
		@{Name="SkontoSumm";Expression={""}},
		@{Name="Export";Expression={""}},
		@{Name="RechnNr";Expression={""}},
		@{Name="Markiert";Expression={""}},
		@{Name="LNR";Expression={"1"}},
		@{Name="Waehrung";Expression={""}}
	)
	
	$rech | select -Property $RechFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\Rechnung.CSV -Force @Encoding -Verbose
	
		
