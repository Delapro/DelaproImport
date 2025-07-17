# DelaproImport
Sammlung von Programmen und Scripten zum Import von Daten ins Delapro

Die Cmdlets in AnalyzeData.PS1 können zur Analyze einer neuen, unbekannten Datenbank verwendet werden.

Bei der generellen Vorgehensweise auch immer wieder die $Error Variable abfragen um bei Projektionen mittels Select-Object Problemfälle ermitteln zu können.


Falls Geschwindigkeit oder Speicher beim Erzeugen der CSV-Dateien ein Problem werden könnte. evtl. die Daten in ein ArrayList schreiben und damit puffern und wenn eine bestimmte Größe erreich wurde die Daten auf die Platte schreiben und Puffer wieder von neuem füllen. Siehe: https://youtu.be/B06AKXW2bDk?t=1660, "
When Memory Fights Back - Jonas Sommer Nielsen - PSConfEU 2025"
