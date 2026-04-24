@echo off
set MODEL_PATH=C:\Models\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-Q8_0.gguf
set CHAT_TEMPLATE_PATH=%~dp0tool_chat_template_qwen3coder_research.jinja
if "%LLAMA_SERVER_EXE%"=="" set LLAMA_SERVER_EXE=llama-server.exe

"%LLAMA_SERVER_EXE%" ^
  -m "%MODEL_PATH%" ^
  -a qwen3.6-research ^
  --no-mmproj ^
  -c 65536 ^
  -ngl all ^
  -fa auto ^
  -ctk q8_0 ^
  -ctv q8_0 ^
  -ub 256 ^
  -b 256 ^
  -np 1 ^
  --device ROCm0 ^
  --reasoning on ^
  --reasoning-format deepseek ^
  --jinja ^
  --chat-template-file "%CHAT_TEMPLATE_PATH%" ^
  --host 127.0.0.1 ^
  --port 8002