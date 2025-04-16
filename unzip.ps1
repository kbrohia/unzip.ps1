$gzFolder = "C:\Users\kyles\Desktop\dmarc"
$logFile = Join-Path $gzFolder "gunzip_log.txt"

Write-Host "`n===== Starting GZ extraction script =====`n"
Add-Content -Path $logFile -Value "`n===== Script started at $(Get-Date) ====="

$gzFiles = Get-ChildItem -Path $gzFolder -Filter *.gz

if ($gzFiles.Count -eq 0) {
    Write-Host "No .gz files found in $gzFolder"
    Add-Content -Path $logFile -Value "No .gz files found in $gzFolder"
}
else {
    foreach ($file in $gzFiles) {
        $gzPath = $file.FullName
        $outPath = [System.IO.Path]::ChangeExtension($gzPath, $null)

        Write-Host "Extracting: $gzPath"
        Add-Content -Path $logFile -Value "Extracting: $gzPath"

        try {
            $sourceStream = [System.IO.File]::OpenRead($gzPath)
            $targetStream = [System.IO.File]::Create($outPath)
            $gzipStream = New-Object System.IO.Compression.GzipStream($sourceStream, [System.IO.Compression.CompressionMode]::Decompress)
            $gzipStream.CopyTo($targetStream)

            $gzipStream.Close()
            $targetStream.Close()
            $sourceStream.Close()

            Write-Host "Extracted to: $outPath"
            Add-Content -Path $logFile -Value "Extracted to: $outPath"

            Remove-Item -Path $gzPath -Force
            Write-Host "Deleted: $gzPath"
            Add-Content -Path $logFile -Value "Deleted: $gzPath"
        }
        catch {
            Write-Host "Error with `${gzPath}`:`n$($_.Exception.Message)" -ForegroundColor Red
            Add-Content -Path $logFile -Value "Error with `${gzPath}`:`n$($_.Exception.Message)"
        }
    }
}

Write-Host "`n===== Script finished at $(Get-Date) =====`n"
Add-Content -Path $logFile -Value "`n===== Script finished at $(Get-Date) ====="
Write-Host "`n===== we are done here little buddy =============="
