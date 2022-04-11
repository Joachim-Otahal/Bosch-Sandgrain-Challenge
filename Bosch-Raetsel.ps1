<#
Bosh Rätsel https://www.facebook.com/BoschKarriere/photos/a.210421252381646/4968773053213085
Unklare Definition:
Was ist mit Sandkörnern die über den Rand gehen? Bei mir fallen die vom Brett und sind verloren.
Powershell Variante, einfach nur weil ich die letzten 2,5 Jahre fast nur Powershell gemacht habe.
#>

$StartDate = Get-Date
$OutFile="c:\tmp\Bosch-Raetsel-" + $StartDate.ToString("yyyy-MM-dd_HH-mm-ss") + ".csv"
$Board = New-Object 'object[,]' 100,100
for ($y=0;$y -lt 100;$y++) {
    for ($x=0;$x -lt 100;$x++) {
        $Board[$x,$y] = [int]0
    }
}
$Board[48,49] = [int]1

for ($i=0;$i -lt 20000;$i++) {
    $Board[49,49]++
    while ($Board.Where({$_ -ge 4})) {
        for ($y=0;$y -lt 100;$y++) {
            for ($x=0;$x -lt 100;$x++) {
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
    if ($i/100 -eq [Math]::Floor($i/100)) { Write-Host "Iteration $i" }
}
$EndDate = Get-Date
[math]::Ceiling(($EndDate - $StartDate).TotalSeconds)

$count0=$count1=$count2=$count3=[int]0
Out-File -FilePath $OutFile -NoNewline -Encoding utf8 -InputObject '"y\x";'
for ($x=0;$x -lt 99;$x++) {
    Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$(($x-49).ToString());"
}
Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "$(($x-49).ToString())"
for ($y=0;$y -lt 100;$y++) {
    Out-File -FilePath $OutFile -Append -NoNewline -Encoding utf8 -InputObject "$(($y-49).ToString());"
    for ($x=0;$x -lt 100;$x++) {
        if ($x -ne 99) {
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
