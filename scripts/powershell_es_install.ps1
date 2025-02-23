$DownloadUrl = 'https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/PowerShellEditorServices.zip';
$ZipPath = "$HOME/PowerShellEditorServices.zip";
$InstallPath = "$HOME/.local/PowerShellEditorServices";
Invoke-WebRequest -Method 'GET' -Uri $DownloadUrl -OutFile $ZipPath;
Expand-Archive -Path $ZipPath -DestinationPath $InstallPath;
Remove-Item $ZipPath
