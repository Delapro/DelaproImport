# Hier sind gesammelte Hilfsfunktionen wo für den Import benötigt werden

Function Invoke-Umlaute {
	[CmdletBinding()]
	Param(
		[string]$csvFile,
		[string]$DestFile
	)

	$iso=[System.Text.Encoding]::GetEncoding("ibm850")
	$utf8 = [System.Text.Encoding]::UTF8
	If (Test-Path $DestFile) {
		Remove-Item $DestFile
	}

	Get-Content $csvFile -ReadCount 1 | ForEach-Object {[System.Text.Encoding]::Convert($utf8, $iso, $utf8.GetBytes($_+[char]13+[char]10)) | Add-Content -Path $DestFile -Encoding Byte}

}

Function MoaNr {$n=$args[0]; $s=$n.IndexOf("/"); $k=KunNr $n.SubString(0,$s); $m=$n.SubString(($s+5),2).TrimStart("0").PadLeft(2); $j=$n.SubString(($s+3),2); "$k$m$j" }

Function KunNr { ([int]$args[0]).ToString().PadLeft(3) }

Function TechNr { ([int]$args[0]).ToString().PadLeft(3) }

Function RechNr { $r=$args[0]; $r.SubString(2, 4) + $args[1].Replace(" ", "0") + $r.SubString($r.length-3) }

Function AuftrNr {$a=$args[0]; $a.ToString().PadLeft(6, "0")}

Function AuftragArt {$a=$args[0]; switch($a) {0 {"R"} 1 {"G"} 2 {"K"} 3 {"T"} 4 {"V"} 5 {"A"}  default {""}  } }

# TODO: Noch abklären, ob ArtikelGruppe verwendet werden kann, wahrscheinlich obsolet
Function ArtArt {$a=$args[0]; switch($a) {0 {"L"} 1 {"L"} 2 {" "} 3 {"T"} } }

Function Artikelgruppe {          $n=$args[0];  # Nummer
					$l=$args[1];  # Liste
					$k=$args[2];  # Kenner
					$a=$args[3];   # Abteilung
					
					$g=" "
					
					If ($k -eq 1) {
						if ($a -eq 0) {
							$g="E"
						} elseif ($a -eq 1) {
							$g = "Z"
						} else {
							$g = "F"
						}
					} elseif ($k -ge 3) {
						$g="T"
					} else {
						$g="L"
					}
					
					$g
				}

# Material Allgemein:  Liste= 0 AND Kenner= 1
# Edelmetall: Liste= 0 AND Kenner= 1 AND Abteilung= 0
# Zähne: Liste= 0 AND Kenner= 1 AND Abteilung= 1
# Sonstiges Material: Liste= 0 AND Kenner= 1 AND Abteilung= 2
# Texte und Sonderartikel: Liste= 0 AND Kenner >= 3
# Technikersplitting: Liste = 0 AND Kenner = 2


# Umwandlung von Lnummer in Delapro konforme Fassung:
Function BelBebNr {$n=$args[0].TrimEnd()
			    $l=$n.Substring(1)
			    $b=""
			    If ($n.contains(".")) {
				$l = $n.replace(".", "")
				$b= "BEBZ"
			    } else {
				    switch ($n.SubString(0,1)) {
					"T" {$b=""} 
					"6"  {$b="PLZ7"; $l = $l.PadRight(6,"0")}
					"7"  {$b="BEB7";  $l = $l.PadRight(6, "0")} 
					"8"  {$b="PLZ ";  $l = $l.PadRight(6,"0")}
					"9"  {$b="BEB ";  $l = $l.PadRight(6, "0")} 
					"B" {$b="BEL1";  $l = $l.PadRight(6, "0")} 
					"N" {$b="BEL2";  $l = $l.PadRight(6, "0")} 
				     }
			      } 
			
			      "$l$b" 
}



# Trim anstatt TrimStart ist ok:
Function PosNr {$p=$args[0]; $p.ToString().Trim().PadLeft(3) }

Function PosNrRight {$p=$args[0]; $p.ToString().Trim().PadLeft(7).SubString(4,3) }
