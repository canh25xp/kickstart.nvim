# Set policy to avoid errors
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# Install lua-language-server
$lua_ls_link = "https://github.com/LuaLS/lua-language-server/releases/download/3.10.6/lua-language-server-3.10.6-win32-x64.zip"
$lua_ls_install_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$lua_ls_src_path = "$lua_ls_install_dir\lua-language-server.zip"
$lua_ls_dir = "$lua_ls_install_dir\lua-language-server"

mkdir $lua_ls_install_dir

# Download file, ref: https://stackoverflow.com/a/51225744/6064933
Invoke-WebRequest $lua_ls_link -OutFile "$lua_ls_src_path"

# Extract the zip file using 7zip, ref: https://stackoverflow.com/a/41933215/6064933
7z x "$lua_ls_src_path" -o"$lua_ls_dir"

rm $lua_ls_src_path = "$lua_ls_install_dir\lua-language-server.zip"

# Setup PATH env variable, ref: https://stackoverflow.com/q/714877/6064933
#[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$lua_ls_dir\bin", "Machine")
