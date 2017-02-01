# MNGruppe enthält die Materialgruppen für den Prothetikpass.

	$matgr = Invoke-SqlCmd -Query "SELECT * FROM MNGruppe" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName  -Username $user -Password $pass
	
	
#	ID Gruppe Bezeichnung
#	-- ------ -----------
#	 1      0 NICHT BELEGT (LEER LASSEN)
#	 2      1 Legierungen
#	 3      2 Zähne
#	 4      3 Hilfs-/Fertigteile
#	 5      4 Lote
#	 6      5 Verblendmaterial Kunststoff
#	 7      6 Verblendmaterial Keramik
#	 8      7 Basiskunststoffe
#	 9      8 Modellguß
#	10      9 Drähte
#	11     10 Klebstoffe
#	12     11 Schrauben
#	13     12 Implantat
