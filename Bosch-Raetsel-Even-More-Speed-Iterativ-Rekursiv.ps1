<#
Bosch Rätsel https://www.facebook.com/BoschKarriere/photos/a.210421252381646/4968773053213085
Unklare Definition:
Was ist mit Sandkörnern die über den Rand gehen? Bei mir fallen die vom Brett und sind verloren.
Powershell Variante, einfach nur weil ich die letzten 2,5 Jahre fast nur Powershell gemacht habe.

https://github.com/Joachim-Otahal/Bosch-Sandgrain-Challenge

Speed 2 Iterativ Variante, von 1770 Sekunden zu 309 Sekunden und jetzt 59 Sekunden (Ryzen 5950x).
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

#### Iteration-array für pseudo-rekursion
# Diesen Stil hätte ich gleich nehmen können, aber war anfangs zu faul da
# anfälliger für Endlos-Schleifen. Da muss abgewogen werden ob der Programmieraufwand
# und spätere Kostenersparnis sich lohnen. Das hier ist noch das einfachstmögliche
# Beispiel einer solchen Implementierung mit unilimiterter Rekursion.
# Es ginge noch schneller wenn wir das maximale Rekursionlimit festlegen und das array fix als .NET object definieren.

$Depth = -1
$DepthArray=@{}

#### loop

for ($i=0;$i -lt $Iterationen;$i++) {
    #### Einzelnes Sandkorn
    $Board[$DropX,$DropY]++
    if ($Board[$DropX,$DropY] -ge 4) {
        $Depth++
        $DepthArray["$Depth"]=@($DropX,$DropY)
        while ($Depth -ge 0) {
            if ($Board[$DepthArray["$Depth"][0],$DepthArray["$Depth"][1]] -ge 4) {
                $x=$DepthArray["$Depth"][0]
                $y=$DepthArray["$Depth"][1]
                $Board[$DepthArray["$Depth"][0],$DepthArray["$Depth"][1]] -= 4
                $Depth--
                if ($x -gt 0) {
                    $Board[($x-1),$y]++
                    if ($Board[($x-1),$y] -ge 4) {
                        $Depth++
                        $DepthArray["$Depth"]=@(($x-1),$y)
                    }
                }
                if ($y -gt 0) {
                    $Board[$x,($y-1)]++
                    if ($Board[$x,($y-1)] -ge 4) {
                        $Depth++
                        $DepthArray["$Depth"]=@($x,($y-1))
                    }
                }
                if ($x+1 -lt $BoardXSize) {
                    $Board[($x+1),$y]++
                    if ($Board[($x+1),$y] -ge 4) {
                        $Depth++
                        $DepthArray["$Depth"]=@(($x+1),$y)
                    }
                }
                if ($y+1 -lt $BoardYSize) {
                    $Board[$x,($y+1)]++
                    if ($Board[$x,($y+1)] -ge 4) {
                        $Depth++
                        $DepthArray["$Depth"]=@($x,($y+1))
                    }
                }
            } else {
                $Depth--
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
