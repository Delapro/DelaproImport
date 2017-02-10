# Hier sind gesammelte Hilfsfunktionen wo für den Import benötigt werden

Function Invoke-Umlaute {
	[CmdletBinding()]
	Param(
		[string]$csvFile
	)
#	$csv = get-content $csvFile
#	$c = $csv| % {$_ = $_.replace([char]246,[char]148).replace([char]252,[char]129).replace([char]228,[char]132).replace([char]223,[char]225).replace([char]220,[char]154); $_}
#	#$c | Set-Content Neu.txt  -Encoding Byte
#	#$enc = [system.Text.Encoding]::ASCII
#	#$enc.GetBytes($c) | Set-Content Neu.txt  -Encoding Byte
#	$iso=[System.Text.Encoding]::GetEncoding("ibm850")
#	$utf8 = [System.Text.Encoding]::UTF8
#	$utfBytes=$utf8.GetBytes($c)
#	$isoBytes=[System.Text.Encoding]::Convert($utf8, $iso, $utfBytes)
#	$isoBytes | Set-Content Neu.txt  -Encoding Byte


	$path = $csvFile

	$numberOfBytesToRead = (Dir $path).length

	$fileStream = [System.IO.File]::Open($path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
	$binaryReader = New-Object System.IO.BinaryReader($fileStream)
	[Byte[]] $byteArray = $binaryReader.ReadBytes($numberOfBytesToRead)

	$pos=0
	for ($i = 0; $i -lt $byteArray.Count; $i++) {
      switch ($byteArray[$i]) {
		  246: {$byteArray[$i] = 148}
		  252: {$byteArray[$i] = 129}
		  228: {$byteArray[$i] = 132}
		  223: {$byteArray[$i] = 225}
		  220: {$byteArray[$i] = 154}
	  }
	}

	$fileStream.Close()

	$fileStream = [System.IO.File]::Open($path, [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
	$binaryWriter = New-Object System.IO.BinaryWriter($fileStream)
	$binaryWriter.Write($byteArray)
	$fileStream.Close()

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


# Achtung globale Variable $global:connection muss definiert sein!
Function Invoke-SqlCmd {
	[CmdletBinding()]
	Param(
		[string]$Query,
		[string]$Database,
		[string]$Username,
		[string]$Password
	)
	$com=$global:connection.CreateCommand()
	$com.CommandText=$Query
	$r=$com.ExecuteReader()
	If ($r.hasRows) {
		$dt=[System.Data.DataTable]::new()
		$dt.Load($r)
	}
	$r.Close()
	$dt
		
}

