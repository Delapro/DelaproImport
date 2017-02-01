# BELEGART klassifiziert die Aufträge

	$belegart = Invoke-SqlCmd -Query "SELECT * FROM belegart" -Database $sm.Databases[0].Name -Serverinstance $sm.DomainInstanceName -Username $user -Password $pass
	
#	Definiert sind:
#	Counter BelegTypReferenz DruckText         AbrOptimierer
#	------- ---------------- ---------         -------------
#	      1                0 Rechnung                      0
#	      2                1 Gutschrift                    0
#	      3                2 Kulanz                        0
#	      4                3 Reklamation                   0
#	      5                4 Kostenvoranschlag             0
#	      6                5 Alternativ-Beleg              0
#	      7                6 Lieferschein                  0
#	      8                7 Umbuchung                     0
#	      9                8 Auftrag                       0
#	     10                  Material-Nachweis             0
#	     11                  Patienten-Pass                0
#	
#
#