# Windows Setup

## Assumptions

- `llama.cpp` is cloned into `$HOME\projects\llama.cpp`.
- You are running Windows with AMD drivers and ROCm user-mode stack installed.
- ROCm tar extraction is available at `C:\TheRock\build`.
- OpenSSL is installed at `$HOME\AppData\Local\Programs\OpenSSL\3.4.1`.
- You want OpenAI-compatible local endpoints via `llama-server.exe`.

## Required Software

- llama.cpp Windows install reference: https://llama-cpp.com/getting-started/#how-to-install-llama-cpp-on-windows
- AMD Adrenalin: https://www.amd.com/en/products/software/adrenalin.html
- ROCm for Windows docs: https://rocm.docs.amd.com/en/7.11.0-preview/install/rocm.html
- Strix Halo ROCm selector URL used in this setup: https://rocm.docs.amd.com/en/7.11.0-preview/install/rocm.html?fam=ryzen&gpu=max-pro-395&os=windows&os-version=11_25h2&i=tar
- OpenSSL (Shining Light): https://slproweb.com/products/Win32OpenSSL.html

## Build llama.cpp (ROCm/HIP)

Use the script in this repo:

- `docs/LLAMA.CPP.ps1`

If PowerShell blocks scripts in the current shell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

Run build:

```powershell
.\docs\LLAMA.CPP.ps1
```

Optional home override:

```powershell
.\docs\LLAMA.CPP.ps1 -HomePath "C:\Users\YourUser"
```

## Confirm GPU Backend

Before launching endpoints, verify device discovery:

```powershell
llama-server.exe --list-devices
```

Expected: at least one ROCm/HIP device listed.

If no GPU is listed, you are likely running a CPU-only build.

## Endpoint Launch

Current launch scripts:

- `servers/launch-thinking.cmd` (port 8000)
- `servers/launch-coding.cmd` (port 8001)
- `servers/launch-research.cmd` (port 8002)
- `servers/launch-all-servers.ps1`

Run all endpoints:

```powershell
.\servers\launch-all-servers.ps1
```

## PowerShell Script Execution

If PowerShell blocks `launch-all-servers.ps1`, enable script execution for current session only:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

## Finding llama-server.exe

Launchers use `llama-server.exe` from `PATH` unless `LLAMA_SERVER_EXE` is set.

Verify:

```powershell
Get-Command llama-server.exe
```

Override for current shell if needed:

```powershell
$env:LLAMA_SERVER_EXE = 'C:\path\to\llama-server.exe'
```

## Current Endpoint Profiles

### Thinking (Gemma 4)

- Model: `C:\Models\gemma-4-21b-a4b-it-REAP\gemma-4-21b-a4b-it-REAP-Q6_K.gguf`
- Alias: `gemma-4`
- Port: `8000`
- Context: `65536`
- Template: `servers/tool_chat_template_google-gemma-4-31B-it.jinja`

### Coding (Qwen 3.6)

- Model: `C:\Models\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-Q8_0.gguf`
- Alias: `qwen3.6-coding`
- Port: `8001`
- Context: `8192`
- Template: `servers/tool_chat_template_qwen3coder_coding.jinja`

### Research (Qwen 3.6)

- Model: `C:\Models\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-Q8_0.gguf`
- Alias: `qwen3.6-research`
- Port: `8002`
- Context: `65536`
- Template: `servers/tool_chat_template_qwen3coder_research.jinja`

## Important Runtime Learnings

- If you see `no usable GPU found`, the active binary is missing GPU backend support.
- If Gemma warns about `outdated gemma4 chat template`, force the official template file.
- If model output narrates fake tool calls instead of executing tools, first verify the endpoint template and then add explicit `prompt_append` tool-use instructions in orchestrator agent config.
- If long sessions compact too much, increase context on the endpoint that handles the most turns (often coding).

## Tuning Guidance

- For lower memory pressure: reduce `-c`, `-b`, and `-ub`.
- For lower latency: keep flash attention enabled and avoid oversized batch.
- For better long-session continuity: increase context where compaction is occurring.
- For deterministic coding output: keep request temperature low and prompts concrete.
