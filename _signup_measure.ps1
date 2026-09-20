Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap 'C:\Users\Andrew San Antonio\taxratesystem_mobile\signup.png'
$W = $bmp.Width; $H = $bmp.Height
Write-Output "SIZE=${W}x${H}"
function Hx([int]$x, [int]$y) { $p = $bmp.GetPixel($x, $y); return ('#{0:X2}{1:X2}{2:X2}' -f $p.R, $p.G, $p.B) }
function D([int]$x, [int]$y) { $p = $bmp.GetPixel($x, $y); return (765 - $p.R - $p.G - $p.B) }

function Bands([int]$thr) {
  $bands = New-Object System.Collections.ArrayList
  $cur = $null
  for ($y = 0; $y -lt $H; $y++) {
    $minx = -1; $maxx = -1
    for ($x = 0; $x -lt $W; $x++) { if ((D $x $y) -gt $thr) { if ($minx -lt 0) { $minx = $x }; $maxx = $x } }
    if ($minx -ge 0) {
      if ($null -eq $cur) { $cur = @{ y0 = $y; y1 = $y; minx = $minx; maxx = $maxx } }
      else { if ($minx -lt $cur.minx) { $cur.minx = $minx }; if ($maxx -gt $cur.maxx) { $cur.maxx = $maxx }; $cur.y1 = $y }
    } elseif ($null -ne $cur) { [void]$bands.Add($cur); $cur = $null }
  }
  if ($null -ne $cur) { [void]$bands.Add($cur) }
  return $bands
}

Write-Output '=== BANDS (thr 5) ==='
foreach ($b in Bands 5) {
  $mid = Hx ([int](($b.minx + $b.maxx) / 2)) ([int](($b.y0 + $b.y1) / 2))
  Write-Output ("BAND y=$($b.y0)..$($b.y1) h=$($b.y1 - $b.y0 + 1) x=$($b.minx)..$($b.maxx) w=$($b.maxx - $b.minx + 1) mid=$mid")
}
Write-Output '--- dropdown arrow probe (country field) ---'
foreach ($y in 680..695) {
  $runs = @()
  for ($x = 300; $x -lt 350; $x++) { if ((D $x $y) -gt 40) { $runs += $x } }
  if ($runs.Count -gt 0) { Write-Output "  y=$y runs=$($runs[0])..$($runs[-1]) n=$($runs.Count)" }
}
