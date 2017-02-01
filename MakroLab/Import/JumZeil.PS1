# JUMZEIL sind die Jumbozeilen drin

# benötigt zwingend JUMBO.PS1 vorab!!!

	$jz = Invoke-SqlCmd -Query "SELECT * FROM JumZeil" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
	$juPosFelder=@(
		@{Name="Nummer";Expression={$global:JNrLink[$_.Referenz]}},
		@{Name="ArtNr";Expression={BelBebNr $_.Nummer}},
		"Menge",
		@{Name="Text";Expression={""}},
		@{Name="AuftrTeil";Expression={"1"}},
		@{Name="PreisArt";Expression={"1"}},
		@{Name="Abteilung";Expression={""}},
		"Techniker",
		@{Name="TechProz1";Expression={"100"}},
		@{Name="Techniker2";Expression={""}},
		@{Name="TechProz2";Expression={""}},
		@{Name="Techniker3";Expression={""}},
		@{Name="TechProz3";Expression={""}},
		@{Name="Techniker4";Expression={""}},
		@{Name="TechProz4";Expression={""}},
		@{Name="Techniker5";Expression={""}},
		@{Name="TechProz5";Expression={""}},
		@{Name="Rueckfrage";Expression={""}},
		@{Name="KontaktPkt";Expression={"N"}},
		@{Name="MengenKalk";Expression={""}},
		@{Name="PosNr";Expression={PosNrRight $_.Zeile.ToString()}}
	)
	
	$jz| select -Property $JuPosFelder | ConvertTo-Csv -NoTypeInformation  | Select-Object -Skip 1 | Set-Content -Path $expPath\StueckP2.CSV -Force @Encoding -Verbose
	
	# $jz.Referenz verweist auf $j.Nummer und stellt die Verbindung zwischen Jumbo und Positionen her.



