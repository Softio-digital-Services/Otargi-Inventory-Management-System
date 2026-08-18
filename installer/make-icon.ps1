# Build multi-size icon.ico from logo.png (Windows Vista+ PNG-in-ICO)
param(
    [string]$PngPath = (Join-Path $PSScriptRoot "..\Assets\logo.png"),
    [string]$IcoPath = (Join-Path $PSScriptRoot "..\Assets\icon.ico")
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $PngPath)) { throw "Missing PNG: $PngPath" }

$sizes = @(16, 32, 48, 64, 128, 256)
$src = [System.Drawing.Image]::FromFile($PngPath)
$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ms)

$bw.Write([uint16]0)
$bw.Write([uint16]1)
$bw.Write([uint16]$sizes.Count)

$offset = 6 + (16 * $sizes.Count)
$chunks = New-Object System.Collections.Generic.List[byte[]]

foreach ($size in $sizes) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)
    $pad = [Math]::Max(1, [int][Math]::Round($size * 0.06))
    $inner = $size - (2 * $pad)
    $g.DrawImage($src, $pad, $pad, $inner, $inner)
    $g.Dispose()

    $pngMs = New-Object System.IO.MemoryStream
    $bmp.Save($pngMs, [System.Drawing.Imaging.ImageFormat]::Png)
    [void]$chunks.Add($pngMs.ToArray())
    $pngMs.Dispose()
    $bmp.Dispose()
}

for ($i = 0; $i -lt $sizes.Count; $i++) {
    $size = $sizes[$i]
    $bytes = $chunks[$i]
    $bw.Write([byte][Math]::Min(255, $size))
    $bw.Write([byte][Math]::Min(255, $size))
    $bw.Write([byte]0)
    $bw.Write([byte]0)
    $bw.Write([uint16]1)
    $bw.Write([uint16]32)
    $bw.Write([uint32]$bytes.Length)
    $bw.Write([uint32]$offset)
    $offset += $bytes.Length
}

foreach ($bytes in $chunks) { $bw.Write($bytes) }

$bw.Flush()
$data = $ms.ToArray()
$bw.Close()
$ms.Close()
$src.Dispose()

[System.IO.File]::WriteAllBytes($IcoPath, $data)
Write-Host "Created $IcoPath ($($data.Length) bytes)"
