# Set policy to avoid errors
#Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# Install clangd
$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$download_link = "https://github.com/clangd/clangd/releases/download/18.1.3/clangd-windows-18.1.3.zip"
$download_path = "$tools_dir\clangd.zip"
$install_dir = "$tools_dir\clangd"

#mkdir $tools_dir

Invoke-WebRequest $download_link -OutFile "$download_path"

7z x "$download_path" -o"$install_dir"

rm $download_path

# Setup PATH env variable, ref: https://stackoverflow.com/q/714877/6064933
#[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$lua_ls_dir\bin", "Machine")
