# Local Three-Agent Stack

This repo documents a Windows-first local agent setup for three roles backed by `llama.cpp` and exposed through OpenAI-compatible `llama-server.exe` endpoints:

- Thinking
- Coding
- Research

The working assumption in this repo is:

- `llama.cpp` is cloned into `$HOME\projects\llama.cpp`
- this repo stays separate from your live `opencode` config
- `opencode` and `oh-my-openagent` live outside this repository
- local model endpoints run on ports `8000` through `8002`

This repo does not store live `opencode.json`, secrets, or user-home runtime state. It contains documentation, launch scripts, templates, and example config shapes only.

## Current Layout

The current baseline in this repo is:

- Thinking: Gemma 4 on `http://localhost:8000/v1`
- Coding: Qwen 3.6 35B A3B on `http://localhost:8001/v1`
- Research: Qwen 3.6 35B A3B on `http://localhost:8002/v1`

The current launchers use these server aliases:

- Thinking: `gemma-4`
- Coding: `qwen3.6-coding`
- Research: `qwen3.6-research`

The current server scripts are:

- [servers/launch-thinking.cmd](servers/launch-thinking.cmd)
- [servers/launch-coding.cmd](servers/launch-coding.cmd)
- [servers/launch-research.cmd](servers/launch-research.cmd)
- [servers/launch-all-servers.ps1](servers/launch-all-servers.ps1)

## What This Repo Assumes You Installed

The setup that informed this repo required all of the following on Windows:

- `llama.cpp` source, using the original Windows instructions: https://llama-cpp.com/getting-started/#how-to-install-llama-cpp-on-windows
- AMD Adrenalin: https://www.amd.com/en/products/software/adrenalin.html
- ROCm for Windows, using AMD's current preview docs:
	- generic docs: https://rocm.docs.amd.com/en/7.11.0-preview/install/rocm.html
	- Strix Halo specific config used here: https://rocm.docs.amd.com/en/7.11.0-preview/install/rocm.html?fam=ryzen&gpu=max-pro-395&os=windows&os-version=11_25h2&i=tar
- ROCm extracted from the tarball into `C:\TheRock\build`, which AMD recommended for this setup
- OpenSSL for Windows from Shining Light, installed into `$HOME\AppData\Local\Programs\OpenSSL\3.4.1`: https://slproweb.com/products/Win32OpenSSL.html

## Build Assumptions

This repo assumes:

- `llama.cpp` is at `$HOME\projects\llama.cpp`
- ROCm is at `C:\TheRock\build`
- OpenSSL is at `$HOME\AppData\Local\Programs\OpenSSL\3.4.1`
- the Windows SDK resource compiler is installed
- you are building a HIP-enabled `llama.cpp`, not a CPU-only build

The build script for this repo is:

- [docs/LLAMA.CPP.ps1](docs/LLAMA.CPP.ps1)

If script execution is blocked in the current terminal session, run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

Then run:

```powershell
.\docs\LLAMA.CPP.ps1
```

## Current Runtime Notes

The current launcher setup reflects a few practical lessons from getting this stack working:

- If `llama-server.exe` reports `no usable GPU found`, you are using a CPU-only build or the wrong binary.
- ROCm/HIP is required for GPU offload.
- Gemma 4 works better when launched with an explicit official Gemma 4 chat template instead of relying on an outdated embedded template.
- Qwen coding and research use separate Jinja templates because the built in templates leak tokens into chat.
- You can tweak context size and batch size in the launch scripts to fit your needs.

## opencode and oh-my-openagent Notes

This repo keeps live `opencode` config out of source control, but the working rule is simple:

- the model names referenced by your external `oh-my-openagent.json` must exactly match the model names exposed in your external `opencode.json`

If they do not match exactly, agent binding can fail silently or fall back in confusing ways.

Example config shapes live here:

- [servers/opencode.single-endpoint.json.example](servers/opencode.single-endpoint.json.example)
- [servers/opencode.multi-endpoint.json.example](servers/opencode.multi-endpoint.json.example)

Integration and architecture docs live here:

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/MODELS.md](docs/MODELS.md)
- [docs/SETUP_WINDOWS.md](docs/SETUP_WINDOWS.md)
- [docs/OPENCODE_INTEGRATION.md](docs/OPENCODE_INTEGRATION.md)
- [docs/VALIDATION.md](docs/VALIDATION.md)

## Recommended Bring-Up Order

1. Build the ROCm-enabled `llama.cpp` binary.
2. Verify `llama-server.exe --list-devices` shows the ROCm device.
3. Start the thinking, coding, and research endpoints.
4. Confirm each endpoint responds on `/v1/models` and `/health`.
5. Point external `opencode` config at those endpoints.
6. Make sure `oh-my-openagent` uses exact model names from `opencode.json`.
7. Validate each role independently before relying on multi-agent workflows.

## Files

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/LLAMA.CPP.ps1](docs/LLAMA.CPP.ps1)
- [docs/MODELS.md](docs/MODELS.md)
- [docs/SETUP_WINDOWS.md](docs/SETUP_WINDOWS.md)
- [docs/OPENCODE_INTEGRATION.md](docs/OPENCODE_INTEGRATION.md)
- [docs/VALIDATION.md](docs/VALIDATION.md)
- [servers/launch-thinking.cmd](servers/launch-thinking.cmd)
- [servers/launch-coding.cmd](servers/launch-coding.cmd)
- [servers/launch-research.cmd](servers/launch-research.cmd)
- [servers/launch-all-servers.ps1](servers/launch-all-servers.ps1)
- [servers/tool_chat_template_google-gemma-4-31B-it.jinja](servers/tool_chat_template_google-gemma-4-31B-it.jinja)
- [servers/tool_chat_template_qwen3coder_coding.jinja](servers/tool_chat_template_qwen3coder_coding.jinja)
- [servers/tool_chat_template_qwen3coder_research.jinja](servers/tool_chat_template_qwen3coder_research.jinja)
- [servers/opencode.single-endpoint.json.example](servers/opencode.single-endpoint.json.example)
- [servers/opencode.multi-endpoint.json.example](servers/opencode.multi-endpoint.json.example)

## Safety Boundary

Do not store live `opencode.json`, `oh-my-openagent.json`, secrets, WSL runtime state, or user-home config in this repository.