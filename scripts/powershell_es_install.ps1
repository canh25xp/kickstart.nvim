$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$download_link = "https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/PowerShellEditorServices.zip"
$download_path = "$tools_dir\PowerShellEditorServices.zip"
$install_dir = "$tools_dir\powershell-editor-services"

curl -L $download_link -o $download_path

7z x "$download_path" -o"$install_dir"

Remove-Item $download_path
