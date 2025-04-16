$zipFolder = "C:\Users\kyles\Downloads\newzips"
Get-ChildItem -Path $zipFolder -Filter *.zip | ForEach-Object {
    $destination = $zipFolder
    Expand-Archive -Path $_.FullName -DestinationPath $destination -Force
}
