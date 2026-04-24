# If script execution is blocked for this terminal session, run:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

[CmdletBinding()]
param(
    [string]$HomePath = $HOME,
    [string]$HipPath = 'C:\TheRock\build',
    [string]$GpuTarget = 'gfx1151',
    [int]$Jobs = 16
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$llamaCppRoot = Join-Path $HomePath 'projects\llama.cpp'
$buildDir = Join-Path $llamaCppRoot 'build'
$opensslRoot = Join-Path $HomePath 'AppData\Local\Programs\OpenSSL\3.4.1'
$clangBinDir = Join-Path $HipPath 'lib\llvm\bin'
$windowsSdkRcDir = 'C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64'
$clangExe = Join-Path $clangBinDir 'clang.exe'
$clangxxExe = Join-Path $clangBinDir 'clang++.exe'
$llamaServerExe = Join-Path $buildDir 'bin\llama-server.exe'

if (-not (Test-Path $llamaCppRoot)) {
    throw "llama.cpp root not found: $llamaCppRoot"
}

if (-not (Test-Path $HipPath)) {
    throw "HIP/ROCm path not found: $HipPath"
}

if (-not (Test-Path $opensslRoot)) {
    throw "OpenSSL root not found: $opensslRoot"
}

if (-not (Test-Path $clangExe)) {
    throw "clang.exe not found: $clangExe"
}

if (-not (Test-Path $clangxxExe)) {
    throw "clang++.exe not found: $clangxxExe"
}

if (-not (Test-Path $windowsSdkRcDir)) {
    throw "Windows SDK resource compiler path not found: $windowsSdkRcDir"
}

Write-Host "Using HomePath: $HomePath"
Write-Host "Using llama.cpp root: $llamaCppRoot"
Write-Host "Using HIP path: $HipPath"

$env:OPENSSL_ROOT_DIR = $opensslRoot
$env:HIP_PATH = $HipPath
$env:PATH = "$clangBinDir;$windowsSdkRcDir;$env:PATH"

if (Test-Path $buildDir) {
    Remove-Item $buildDir -Recurse -Force
}

New-Item -ItemType Directory -Path $buildDir | Out-Null

Push-Location $buildDir
try {
    cmake -S .. -G Ninja `
      -DGGML_HIP=ON `
      -DGPU_TARGETS=$GpuTarget `
      -DCMAKE_C_COMPILER="$clangExe" `
      -DCMAKE_CXX_COMPILER="$clangxxExe" `
      -DCMAKE_BUILD_TYPE=Release `
      -DCMAKE_EXE_LINKER_FLAGS="-L $HipPath\lib" `
      -DCMAKE_SHARED_LINKER_FLAGS="-L $HipPath\lib" `
      -DCMAKE_PREFIX_PATH="$HipPath"

    cmake --build . -j $Jobs

    if (-not (Test-Path $llamaServerExe)) {
        throw "Build completed but llama-server.exe was not found at: $llamaServerExe"
    }

    & $llamaServerExe --list-devices
}
finally {
    Pop-Location
}