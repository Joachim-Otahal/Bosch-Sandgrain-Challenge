﻿<#
Bosch Rätsel https://www.facebook.com/BoschKarriere/photos/a.210421252381646/4968773053213085
Unklare Definition:
Was ist mit Sandkörnern die über den Rand gehen? Bei mir fallen die vom Brett und sind verloren.
Powershell Variante, einfach nur weil ich die letzten 2,5 Jahre fast nur Powershell gemacht habe.

https://github.com/Joachim-Otahal/Bosch-Sandgrain-Challenge

Speed Variante, von 1770 Sekunden zu 309 Sekunden (Ryzen 5950x) durch start mit kleinem Suchbereich
welcher bei gefundenem >=4 vergrößert wird etc...

#>

$StartDate = Get-Date

#### Boardgröße

$BoardXSize = [int]100
$BoardYSize = [int]100
$Board = New-Object 'object[,]' $BoardXSize,$BoardYSize
for ($y=0;$y -lt $BoardYSize;$y++) {
    for ($x=0;$x -lt $BoardXSize;$x++) {
        $Board[$x,$y] = [int]0
    }
}

#### Startkorn

$Board[48,49] = [int]1

#### Droppoint

$DropX = [int]49
$DropY = [int]49

#### Interationen aka "Sandkörner"

$Iterationen = [int]20000

#### CSV vom Ergebnis
$OutFile=".\Bosch-Raetsel-" + $StartDate.ToString("yyyy-MM-dd_HH-mm-ss") + ".csv"

#### loop

for ($i=0;$i -lt $Iterationen;$i++) {
    #### Einzelnes Sandkorn
    $Board[$DropX,$DropY]++
    if ($Board[$DropX,$DropY] -ge 4) {
        $xmin=$DropX
        $ymin=$DropY
        $xmax=$DropX+1
        $ymax=$DropY+1
        while ($Board.Where({$_ -ge 4})) {
            $recurseflag=$true
            while ($recurseflag) {
                $recurseflag=$false
                for ($y=$ymin;$y -lt $ymax;$y++) {
                    for ($x=$xmin;$x -lt $xmax;$x++) {
                        if ($Board[$x,$y] -ge 4) {
                            $recurseflag=$true
                            if ($x -gt 0) { $Board[($x-1),$y]++ ; if ($xmin -gt $x-1) {$xmin = $x-1}}
                            if ($y -gt 0) { $Board[$x,($y-1)]++ ; if ($ymin -gt $y-1) {$ymin = $y-1}}
                            if ($x+1 -lt $BoardXSize) { $Board[($x+1),$y]++ ; if ($xmax -lt $x+2) {$xmax=$x+2}}
                            if ($y+1 -lt $BoardYSize) { $Board[$x,($y+1)]++ ; if ($ymax -lt $y+2) {$ymax=$y+2}}
                            $Board[$x,$y] -= 4
                        }
                    }
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
$count0=$Board.Where({$_ -eq 0}).count
$count1=$Board.Where({$_ -eq 1}).count
$count2=$Board.Where({$_ -eq 2}).count
$count3=$Board.Where({$_ -eq 3}).count
Out-File -FilePath $OutFile -NoNewline -Encoding utf8 -InputObject '"y\x";'
for ($x=0;$x -lt $BoardXSize-1;$x++) {
    Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$(($x-[Math]::Floor($BoardXSize/2)+1).ToString());"
}
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "$(($x-[Math]::($BoardXSize/2)).ToString())"
for ($y=0;$y -lt $BoardXSize;$y++) {
    Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$(($y-[Math]::Floor($BoardYSize/2)+1).ToString());"
    for ($x=0;$x -lt $BoardXSize;$x++) {
        if ($x -ne ($BoardXSize-1)) {
            Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$($Board[$x,$y].ToString());"
        } else {
            Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "$($Board[$x,$y].ToString())"
        }
    }
}

Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "$([math]::Ceiling(($EndDate - $StartDate).TotalSeconds)) Sekunden benötigt"

Write-Host "CSV output at $OutFile, ready to be used with your spreadsheet app..."
Write-Host "0: $count0"
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "0: $count0"
Write-Host "1: $count1"
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "1: $count1"
Write-Host "2: $count2"
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "2: $count2"
Write-Host "3: $count3"
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "3: $count3"
Write-Host "Übrige Sandkörner: $($count3*3+$count2*2+$count1)"
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "Übrige Sandkörner: $($count3*3+$count2*2+$count1)"
Write-Host "Verlorene Sandkörner: $($Iterationen-$count3*3-$count2*2-$count1)"
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "Verlorene Sandkörner: $($Iterationen-$count3*3-$count2*2-$count1)"
