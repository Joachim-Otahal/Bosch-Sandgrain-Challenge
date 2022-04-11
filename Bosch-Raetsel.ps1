<#
Bosh Rätsel https://www.facebook.com/BoschKarriere/photos/a.210421252381646/4968773053213085
Unklare Definition:
Was ist mit Sandkörnern die über den Rand gehen? Bei mir fallen die vom Brett und sind verloren.
Powershell Variante, einfach nur weil ich die letzten 2,5 Jahre fast nur Powershell gemacht habe.

Hinweis: Ich ignoriere alle "über die Boardgrenzen Zugriff" Fehler :D.

#>

#### Boardgröße

$BoardXSize = [int]100
$BoardYSize = [int]100
$Board = New-Object 'object[,]' $BoardXSize,$BoardYSize

#### Startkorn

$Board[48,49] = [int]1

#### Droppoint

$DropX = [int]49
$DropY = [int]49

#### Interationen aka "Sandkörner"

$Iterationen = [int]20000

#### CSV vom Ergebnis
$OutFile=".\Bosch-Raetsel-" + $StartDate.ToString("yyyy-MM-dd_HH-mm-ss") + ".csv"

#### Init

$StartDate = Get-Date
for ($y=0;$y -lt $BoardYSize;$y++) {
    for ($x=0;$x -lt $BoardXSize;$x++) {
        $Board[$x,$y] = [int]0
    }
}

for ($i=0;$i -lt $Iterationen;$i++) {
    #### Einzelnes Sandkorn
    $Board[$DropX,$DropY]++
    while ($Board.Where({$_ -ge 4})) {
        for ($y=0;$y -lt $BoardYSize;$y++) {
            for ($x=0;$x -lt $BoardXSize;$x++) {
                if ($Board[$x,$y] -ge 4) {
                    $Board[($x-1),$y]++
                    $Board[$x,($y-1)]++
                    $Board[($x+1),$y]++
                    $Board[$x,($y+1)]++
                    $Board[$x,$y] -= 4
                }
            }
        }
    }
    #### Statusupdate
    if ($i/100 -eq [Math]::Floor($i/100)) { Write-Host "Iteration $i von $Iterationen" }
}
$EndDate = Get-Date
Write-Host "$([math]::Ceiling(($EndDate - $StartDate).TotalSeconds)) Sekunden benötigt"

# Zählen und CSV erstellen
$count0=$count1=$count2=$count3=[int]0
Out-File -FilePath $OutFile -NoNewline -Encoding utf8 -InputObject '"y\x";'
for ($x=0;$x -lt $BoardXSize-1;$x++) {
    Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$(($x-[Math]::Floor($BoardXSize/2)).ToString());"
}
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "$(($x-[Math]::($BoardXSize/2)).ToString())"
for ($y=0;$y -lt $BoardXSize;$y++) {
    Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$(($x-[Math]::Floor($BoardYSize/2)).ToString());"
    for ($x=0;$x -lt $BoardXSize;$x++) {
        if ($x -ne ($BoardXSize-1)) {
            Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$($Board[$x,$y].ToString());"
        } else {
            Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "$($Board[$x,$y].ToString())"
        }
        Switch ($Board[$x,$y]) {
            0 {$count0++}
            1 {$count1++}
            2 {$count2++}
            3 {$count3++}
        }
    }
}

Write-Host "CSV output at $OutFile, ready to be used with your spreadsheet app..."
Write-Host "0: $count0"
Write-Host "1: $count1"
Write-Host "2: $count2"
Write-Host "3: $count3"
Write-Host "Übrige Sandkörner: $($count3*3+$count2*2+$count1)"
Write-Host "Verlorene Sandkörner: $($Iterationen-$count3*3-$count2*2-$count1)"