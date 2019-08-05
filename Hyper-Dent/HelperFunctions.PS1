# hier sind verschiedene Hilfsfunktionen definiert

Function Get-AnredeFromFirma {Param ($firma) ($firma -split [string][char]13+[char]10)[0]}
Function Get-NameFromFirma {Param ($firma) ($firma -split [string][char]13+[char]10)[1]}
Function Get-TitelFromFirma {Param ($firma) Get-NameFromFirma $firma}

Function KunNr { ([int]$args[0]).ToString().PadLeft(3) }

Function Monat { ([int]$args[0]).ToString().PadLeft(2) }

Function Patientenname {
    Param ($vorname, $nachname)
    If ($vorname.Length -eq 0) {
        $nachname
    } else {
        "$($nachname.TrimEnd()), $($vorname.TrimEnd())"
    }
}

Function TechNr { ([int]$args[0]).ToString().PadLeft(3) }

Function BelNr {
    Param($Nr)
    $Nr.Replace(' ', '').PadRight(6, '0')
}

Function BebArt {
    Param(
        $Verzeichnis
    )

    # siehe auch BezTexte2 mit type = 7
    switch ($Verzeichnis) {
        "1" {"BEBZ"}
        "2" {"BEL2"}
        "3" {"BEB7"}
        default {"    "}  # Material
    }
}

Function Artikelgruppe {
    Param(
        $Verzeichnis
    )

    # siehe auch BezTexte2 mit type = 7
    switch ($Verzeichnis) {
        "1" {"L"}
        "2" {"L"}
        "3" {"L"}
        "11" {"E"}
        "12" {"Z"}
        default {"F"}
    }
}

Function AuftrNr {$a=$args[0]; $a.ToString().PadLeft(6, "0")}

# Interpretation des Felds auf_kopf.status
Function AuftragArt {
        switch ($args[0]) {
            "0" {""}  # erfasst
            "1" {"R"}
            "2" {"V"} # je nach anderem Feld auch Kostenaufstellung
            "3" {"L"} # Produktionsauftrag
            "4" {"G"}
            "5" {"K"}
            "6" {"T"}
            "7" {""}  # Lieferschein
            default {"X"}
        }
}

Function PosNr {
    $args[0].ToString().PadLeft(3)
}