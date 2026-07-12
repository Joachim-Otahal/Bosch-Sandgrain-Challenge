<#
Bosch Rätsel https://www.facebook.com/BoschKarriere/photos/a.210421252381646/4968773053213085
Unklare Definition:
Was ist mit Sandkörnern die über den Rand gehen? Bei mir fallen die vom Brett und sind verloren.
Powershell Variante, einfach nur weil ich die letzten 2,5 Jahre fast nur Powershell gemacht habe.

https://github.com/Joachim-Otahal/Bosch-Sandgrain-Challenge

Speed 2 Iterativ Variante, von 1770 Sekunden zu 309 Sekunden zu 59 Sekunden jetzt 37 Sekunden (Ryzen 5950x).
welcher bei gefundenem >=4 vergrößert wird etc...

Update 2026: Lets output an PNG, shall we? Since we learned how to paint for my solar data...

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

# Actual officially defined start position
# $Board[48,49] = [int]1 
# But this looks better, symmetrical
$Board[49,49] = [int]1

#### Droppoint

$DropX = [int]49
$DropY = [int]49

#### Interationen aka "Sandkörner"

$Iterationen = [int]20000

#### PNG vom Ergebnis
$PNGFileTemplate=".\Bosch-Raetsel-" + $StartDate.ToString("yyyy-MM-dd") + " "
# Ausgabe jede "X-te" iteration...
$PNGEach = 1000

#### Iteration-array für pseudo-rekursion
# Diesen Stil hätte ich gleich nehmen können, aber war anfangs zu faul da
# anfälliger für Endlos-Schleifen. Da muss abgewogen werden ob der Programmieraufwand
# und spätere Kostenersparnis sich lohnen. Das hier ist noch das einfachstmögliche
# Beispiel einer solchen Implementierung mit unilimiterter Rekursion.
# Es ginge noch schneller wenn wir das maximale Rekursionlimit festlegen und das array fix als .NET object definieren.
####
# Hier die "Limit Rekustionstiefe" Variante mit .NET array.

$Depth = -1
$DepthArray = New-Object 'object[,]' ($BoardXSize*$BoardYSize),2


#### loop

for ($i=0;$i -lt $Iterationen;$i++) {

    # Bildchen malen, Iternation 0 mitnehmen...
    if ($i%$PNGEach -eq 0 -or $i+1 -ge $Iterationen) {
        Write-Host "Bildchen bei Iteration $i von $Iterationen"
        # Zählen und CSV erstellen
        $count0=$Board.Where({$_ -eq 0}).count
        $count1=$Board.Where({$_ -eq 1}).count
        $count2=$Board.Where({$_ -eq 2}).count
        $count3=$Board.Where({$_ -eq 3}).count

        $PNGFile = $PNGFileTemplate + ([String]$i).PadLeft([Math]::Ceiling([Math]::Log10($Iterationen+1)),"0")+".png"
        $SizeX=$SizeY=2160
        $PenWidth = $SizeX/1280 # em Size, to get pixel would be 2*$pict.DpiX/72.
        $bmp = [System.Drawing.Bitmap]::new($SizeX,$SizeY,[System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $pict = [System.Drawing.Graphics]::FromImage($bmp)
        $pict.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias # Without there is no font-aliasing for DrawPath and DrawLine, rendered as old-style-pixel. https://www.codeproject.com/Articles/15394/Drawing-smooth-text-and-pictures-on-the-extended-g
        $BrushWhite = [System.Drawing.Brushes]::White
        $BrushBlack = [System.Drawing.Brushes]::Black
        $BrushLightGray  = [System.Drawing.Brushes]::LightGray
        $BrushDarkGray = [System.Drawing.Brushes]::DarkGray
        $BrushGrain = @( [System.Drawing.SolidBrush]::new("#FFFFFFd7"), # 0
                        [System.Drawing.SolidBrush]::new("#FFb9cfd3"), # 1
                        [System.Drawing.SolidBrush]::new("#FF729fcf"), # 2
                        [System.Drawing.SolidBrush]::new("#FF000080"), # 3
                        [System.Drawing.SolidBrush]::new("#FFFF0000")  # 4 should never appear by design
        )
        $FontTitleSize  = $SizeY/55
        $FontTitle      = [System.Drawing.Font]::new("Consolas",$FontTitleSize)
        $FontScaleSize  = $SizeY/$BoardYSize/1.5
        $FontScale      = [System.Drawing.Font]::new("Consolas",$FontScaleSize)
        # Get real font size results from a single "drawn" character... is only approx since some..
        $MeasureString = "0123456789"*1000
        $FontTitleSizeX = $pict.MeasureString($MeasureString,$FontTitle).Width/10001 # Why is measurestring such a failure... Exactly 0.01% off, tested with Courier New as well...
        $FontTitleSizeY = $pict.MeasureString("█",$FontTitle).Height
        $FontScaleSizeX = $pict.MeasureString($MeasureString,$FontScale).Width/10001
        $FontScaleSizeY = $pict.MeasureString("█",$FontScale).Height

        $pict.FillRectangle($BrushWhite,-1,-1,$SizeX+2,$SizeY+2) # White backgroud: We have to use "one pixellarger than picture size", else anti-alias will leaves a dark frame on borders.
        # Title / Legend
        $pict.DrawString("Bosch Grain-Rätsel, Iteration $i",$FontTitle,$BrushBlack,$FontTitleSizeX*1,$FontTitleSizeY/10)
        for ($j=0;$j -lt 4;$j++) {
            $pict.FillRectangle($BrushGrain[$j],$FontTitleSizeX*(42+$j*4),$FontTitleSizeY/10,$FontTitleSizeX*3,$FontTitleSizeY*0.85)
            if ($j -lt 3) {
                $pict.DrawString("$j",$FontTitle,$BrushBlack,$FontTitleSizeX*(43+$j*4),$FontTitleSizeY/10)
            } else {
                $pict.DrawString("$j",$FontTitle,$BrushWhite,$FontTitleSizeX*(43+$j*4),$FontTitleSizeY/10)
            }
        }
        # Grid
        $GridXDivisions = $BoardXSize
        $GridYDivisions = $BoardYSize

        $XDigits        = [Math]::Ceiling([Math]::Log10($BoardXSize+1))
        $YDigits        = [Math]::Ceiling([Math]::Log10($BoardYSize+1))
        $GridX0         = [int]($FontScaleSizeX*(1+$YDigits)) # left, leave enough for numbers
        $GridY0         = [int]($FontTitleSizeY*1.5) # top
        $GridX1         = $SizeX-[int]($FontScaleSizeX) # right
        $GridY1         = $SizeY-[int]($FontScaleSizeX*(1+$XDigits)) # bottom, leave enough for numbers
        $GridXArea      = $GridX1-$GridX0
        $GridYArea      = $GridY1-$GridY0
        $GridXStep      = $GridXArea/$GridXDivisions
        $GridYStep      = $GridYArea/$GridYDivisions
        # Make grid background "black"
        $pict.FillRectangle($BrushBlack,$GridX0,$GridY0,$GridXArea,$GridYArea)
        # Legend
        for ($x=0;$x -lt $BoardXSize;$x++) { # x rotated 90°
            #$pict.DrawString("$($x-$DropX)",$FontScale,$BrushBlack,$GridX0+$x*$GridXStep,$GridY1)
            $pict.TranslateTransform($GridX0+$x*$GridXStep+$FontScaleSizeY*0.9,$GridY1) # Point of rotation, MOVES (not set) "this is your new zero point".
            $pict.RotateTransform(90) # Degree, is "additional" not "absolute from 0°"
            $pict.DrawString("$($x-$DropX)".PadLeft($YDigits," "),$FontScale,$BrushBlack,0,0)
            $pict.RotateTransform(-90) # has to be done "relative to current change"
            $pict.TranslateTransform(-$pict.Transform.OffsetX,-$pict.Transform.OffsetY) # has to be done "relative to current change"
        }
        for ($y=0;$y -lt $BoardYSize;$y++) { # y
            $pict.DrawString("$($y-$DropX)".PadLeft($XDigits," "),$FontScale,$BrushBlack,$FontScaleSizeX/2,$GridY0+$y*$GridYStep)
        }

        # Grains
        for ($x=0;$x -lt $BoardXSize;$x++) {
            for ($y=0;$y -lt $BoardYSize;$y++) {
                $pict.FillRectangle($BrushGrain[$($Board[$x,$y])],$GridX0+$x*$GridXStep,$GridY0+$y*$GridYStep,$GridXStep*0.97,$GridYStep*0.97) # A "grain"
            }
        }
        $bmp.Save($PNGFile,[System.Drawing.Imaging.ImageFormat]::Png)
        $pict.Dispose()
        $bmp.Dispose()
        #$null = Read-Host "pause..."
    }
    
    #### Einzelnes Sandkorn ablegen
    $Board[$DropX,$DropY]++
    if ($Board[$DropX,$DropY] -ge 4) {
        $Depth++
        $DepthArray[$Depth,0]=$DropX
        $DepthArray[$Depth,1]=$DropY
        while ($Depth -ge 0) {
            if ($Board[$DepthArray[$Depth,0],$DepthArray[$Depth,1]] -ge 4) {
                $x=$DepthArray[$Depth,0]
                $y=$DepthArray[$Depth,1]
                $Board[$DepthArray[$Depth,0],$DepthArray[$Depth,1]] -= 4
                $Depth--
                if ($x -gt 0) {
                    $Board[($x-1),$y]++
                    if ($Board[($x-1),$y] -ge 4) {
                        $Depth++
                        $DepthArray[$Depth,0]=$x-1
                        $DepthArray[$Depth,1]=$y
                    }
                }
                if ($y -gt 0) {
                    $Board[$x,($y-1)]++
                    if ($Board[$x,($y-1)] -ge 4) {
                        $Depth++
                        $DepthArray[$Depth,0]=$x
                        $DepthArray[$Depth,1]=$y-1
                    }
                }
                if ($x+1 -lt $BoardXSize) {
                    $Board[($x+1),$y]++
                    if ($Board[($x+1),$y] -ge 4) {
                        $Depth++
                        $DepthArray[$Depth,0]=$x+1
                        $DepthArray[$Depth,1]=$y
                    }
                }
                if ($y+1 -lt $BoardYSize) {
                    $Board[$x,($y+1)]++
                    if ($Board[$x,($y+1)] -ge 4) {
                        $Depth++
                        $DepthArray[$Depth,0]=$x
                        $DepthArray[$Depth,1]=$y+1
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

# Write-Host "0: $count0"
# Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "0: $count0"
# Write-Host "1: $count1"
# Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "1: $count1"
# Write-Host "2: $count2"
# Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "2: $count2"
# Write-Host "3: $count3"
# Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "3: $count3"
# Write-Host "Übrige Sandkörner: $($count3*3+$count2*2+$count1)"
# Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "Übrige Sandkörner: $($count3*3+$count2*2+$count1)"
# Write-Host "Verlorene Sandkörner: $($Iterationen-$count3*3-$count2*2-$count1)"
# Out-File -FilePath $OutFile -Append -Encoding utf8 -InputObject "Verlorene Sandkörner: $($Iterationen-$count3*3-$count2*2-$count1)"
