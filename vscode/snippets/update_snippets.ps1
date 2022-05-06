${GLOBAL_WORKSPACE}="${Env:APPDATA}\Code\User\snippets"

if ($IsWindows -or $Env:OS) {
    if (-not $(Test-Path ${GLOBAL_WORKSPACE})) {
        New-Item ${GLOBAL_WORKSPACE} -ItemType directory -Force
    }
   Copy-Item -Verbose *.json ${GLOBAL_WORKSPACE}
}
