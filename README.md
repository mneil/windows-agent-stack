# Local Three-Agent Stack

This repo documents a Windows-first local agent setup for qwen3.8 backed by `llama.cpp` and exposed through OpenAI-compatible `llama-server.exe` endpoints:

The working assumption in this repo is:

- `llama.cpp` is cloned into `$HOME\projects\llama.cpp
- local model endpoints run on ports `8000`

## Current Layout

The current baseline in this repo is:

- Thinking: Qwen 3.8 27B on `http://localhost:8000/v1`

The current launchers use these server aliases:

- Thinking: `qwen3.8`

The current server scripts are:

- [servers/launch-thinking.cmd](servers/launch-thinking.cmd)

## What This Repo Assumes You Installed

The setup that informed this repo required all of the following on Windows:

- `llama.cpp` source, using the original Windows instructions: https://llama-cpp.com/getting-started/#how-to-install-llama-cpp-on-windows
- AMD Adrenalin: https://www.amd.com/en/products/software/adrenalin.html
- ROCm for Windows, using AMD's current preview docs:
	- generic docs: https://rocm.docs.amd.com/en/docs-10.0.0/about/release-notes.html
	- Strix Halo specific config used here: https://rocm.docs.amd.com/en/docs-10.0.0/install/rocm.html?fam=ryzen&w=compute&gpu=amd-ryzen-ai-max-395&os=windows&windows-ver=11&i=tar&gfx=gfx1151
- ROCm extracted from the tarball into `C:\TheRock\build`, which AMD recommended for this setup
- OpenSSL for Windows from Shining Light, installed into `$HOME\AppData\Local\Programs\OpenSSL\3.4.1`: https://slproweb.com/products/Win32OpenSSL.html

## Build Assumptions

This repo assumes:

- `llama.cpp` is at `$HOME\projects\llama.cpp` (build `b10327`)
- ROCm is at `C:\TheRock\build` (v10.0.0 - it's broken, see notes)
- OpenSSL is at `$HOME\AppData\Local\Programs\OpenSSL\3.4.1`
- the Windows SDK resource compiler is installed
- you are building a HIP-enabled `llama.cpp`, not a CPU-only build

The build script for this repo is:

- [build/LLAMA.CPP.ps1](build/LLAMA.CPP.ps1)

If script execution is blocked in the current terminal session, run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

Then run:

```powershell
.\build\LLAMA.CPP.ps1
```

## Current Runtime Notes

The current launcher setup reflects a few practical lessons from getting this stack working:

- [fix ROCm](https://github.com/ggml-org/llama.cpp/issues/22570#issuecomment-4775122825) for 7.1.1 works for 10.0.0
	>Fix (one line, no toolset downgrade) — in ...C:\TheRock\build\lib\llvm\lib\clang\23\include\__clang_hip_runtime_wrapper.h, in the #if !defined(__HIPCC_RTC__) block, put the forward-declares include before \<cmath\>:
	```c
	#include <__clang_cuda_math_forward_declares.h>
	#include <cmath>
	```
- If `llama-server.exe` reports `no usable GPU found`, you are using a CPU-only build or the wrong binary.
- ROCm/HIP is required for GPU offload.
- You can tweak context size and batch size in the launch scripts to fit your needs.

## Recommended Bring-Up Order

1. Build the ROCm-enabled `llama.cpp` binary.
2. Verify `llama-server.exe --list-devices` shows the ROCm device.
3. Start the thinking endpoints.
4. Confirm each endpoint responds on `/v1/models` and `/health`.
