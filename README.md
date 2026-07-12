# Bosch-Sandgrain-Challenge
Bosch made a litte challenge...

Orignal: https://www.facebook.com/BoschKarriere/photos/a.210421252381646/4968773053213085

# Update Juli 2026 - Bosch-Raetsel-2026-PNG-output.ps1
Ausgabe als PNG, alle 1000 iterationen. Nachdem ich durch meine Solarsteuerung weiß wie man bildchen malt..

<img width="2160" height="2160" alt="Bosch-Raetsel-2026-07-12 20000" src="https://github.com/user-attachments/assets/8f98d04f-2bf4-4e13-b6a7-b65799204438" />

# Text vom Posting:
Einfache Berechnungsvorschriften können komplexe Formen hervorbringen, im Computer genau wie in der Natur. Beispiele sind fraktale Formen und zelluläre Automaten. Nehmen wir ein Feld der Größe 100x100 und platzieren ein Sandkorn auf x/y -1/0. Für jeden Rechenschritt lassen wir ein weiteres Sandkorn auf 0/0 fallen, welche ab einer Höhe von 4 zu den Rändern runterrutschen. Die Felder am Rand des „Sandkastens“ bleiben unverändert.
Implementiere einen Simulator für die Berechnung des Sandhaufens und beantworte folgende Frage: Wie viele Felder sind nach 20.000 Sandkörnern noch leer, und wie viele Felder haben 1, 2 oder 3 Sandkörner? 

# Bild vom Posting:
![Bosch-Simulator-Rätsel-278329595_4968773036546420_3197355297034891896_n](https://user-images.githubusercontent.com/10100281/162838834-d7dee6fc-7012-4932-a4e5-a79e99b03542.jpg)

# Meinung:
Die Definition ist nicht ganz genau klar, was ist mit Körner welche über den Rand fallen? Das Bosch Bild lässt mich auch den genau verwendeten Algorithmus hinterfragen.

# Mein Ergebnis
Wichtiges Detail zu meiner Version: Ich nutze keine Rekursion, die wäre aber normalerweise nötig. Nur Powershell und Rekursion vermeide ich wenn es möglich ist - dafür ist Powershell zu ineffizient. Hier das Bild soweit es in Libreoffice Calc darstellbar ist - Dem Programm fehlt noch SO VIEL, aber sie kümmern sich immer um die Optik...):

![Bosch-Raetsel-2022-04-11_22-34-26](https://user-images.githubusercontent.com/10100281/162839146-e4b27fbc-917c-4164-901d-b90dbca738d5.png)
