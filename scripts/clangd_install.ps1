$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$download_link = "https://github.com/clangd/clangd/releases/download/18.1.3/clangd-windows-18.1.3.zip"
$download_path = "$tools_dir\clangd.zip"
$install_dir = "$tools_dir\clangd"

curl -L $download_link -o $download_path

7z x "$download_path" -o"$install_dir"

Remove-Item $download_path
