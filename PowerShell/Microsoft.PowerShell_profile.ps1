


set-alias vim "${env:ProgramFiles(x86)}\Vim\vim82\vim.exe"
set-alias code "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe"

function go_pwd {
    $env:GOPATH="${PWD}"
}

function s {set-location ${env:USERPROFILE}\workspace-scratch}
