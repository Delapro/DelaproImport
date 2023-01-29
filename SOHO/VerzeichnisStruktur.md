# Verzeichnisstruktur

- SOHO
  - Daten
    - DATEN
      - BEB09
        - FORMULAR
          - Enthält die ganzen Formulare, CR2-Dateien, also Crystal Report
        - FORM_DEFEKT
        - FORM_MUSTER
        - FORM_SICH
        - Jumbos
          - freie Struktur von Jumbos
        - NETINSTALL
          - VERSION_02_10_4100
            - setup.exe für Installation
        - PAKETE
        - Postausgang
          - Verzeichnisse von Kunden mit PDF-Dateien
        - SCRIPTE
        - ZAHN
        - ZAHNDHZ
          - enthält *.SOS Dateien
        - VORMONAT
        - XML
          - Verzeichnisse von Kunden mit Kundennamen die XML-Dateien enthalten
            - Die Unterverzeichnisse setzen sich aus YYMMDDKNR also Jahr, Monat, Tag und Kundennummer zusammen
              In den Verzeichnissen befinden sich die einzelnen XML-Dateien und immer eine ZIP-Datei mit den XML-Dateien aus dem Verzeichnis
        - ZAHN
          - enthält JMB-Dateien für Zahnschema, Zahn.INI, Zahn.BMP
        - ZAHNDHZ
          - enthält JMB-Dateien für Zahnschema, Zahn.INI, Zahn.BMP
      - Import
        - Preistabellen
          - BEB
          - BELII
          - PLZ
                Unterverzeichnisse mit Datumsangaben, die Verzeichnisse enthalten TXT-Dateien mit Preispositionen
      - Scan
  - Datenbanken
      - enthält die Datenbanken, SOHOARCH.FDB, SOHOBILD.FDB, SOHOSECU.FDB, SOHOTECH.FDB
      - Backup
        -enthält *.BCK also Backupdateien der FDB-Dateien sowie Scripte für Firebird
  - Tools


P:\SOHO\Daten\DATEN
ZeitAdmin.exe
W32ptech.exe
sohozeit.exe   

P:\SOHO\Daten\DATEN\FORMULAR
W32ptech.exe

Dateiendungen *.SOS, *.QR2, *.CDS, *.JMB
