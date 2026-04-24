$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $env:LLAMA_SERVER_EXE) {
    $llamaCommand = Get-Command llama-server.exe -ErrorAction SilentlyContinue
    if (-not $llamaCommand) {
        throw @"
llama-server.exe was not found on PATH.

Fix one of these first:
1. Add llama-server.exe to PATH and restart the shell.
2. Set a process-local override before launching:
   `$env:LLAMA_SERVER_EXE = 'C:\path\to\llama-server.exe'

Then run .\servers\launch-all-servers.ps1 again.
"@
    }
}

$targets = @(
    @{ Name = 'Thinking'; Script = 'launch-thinking.cmd' },
    @{ Name = 'Coding'; Script = 'launch-coding.cmd' },
    @{ Name = 'Research'; Script = 'launch-research.cmd' }
)

foreach ($target in $targets) {
    $cmdPath = Join-Path $scriptRoot $target.Script
    if (-not (Test-Path $cmdPath)) {
        throw "Missing server launcher: $cmdPath"
    }

    Start-Process -FilePath 'powershell.exe' -WorkingDirectory $scriptRoot -ArgumentList @(
        '-NoExit',
        '-Command',
        "& '$cmdPath'"
    ) | Out-Null
}

Write-Host 'Launched thinking, coding, and research server windows.'
