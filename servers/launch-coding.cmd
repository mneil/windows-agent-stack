@echo off
set MODEL_PATH=C:\Models\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-Q8_0.gguf
set CHAT_TEMPLATE_PATH=%~dp0tool_chat_template_qwen3coder_coding.jinja
if "%LLAMA_SERVER_EXE%"=="" set LLAMA_SERVER_EXE=llama-server.exe

"%LLAMA_SERVER_EXE%" ^
  -m "%MODEL_PATH%" ^
  -a qwen3.6-coding ^
  -c 8192 ^
  -ngl 999 ^
  -fa 1 ^
  -ctk q8_0 ^
  -ctv q8_0 ^
  -ub 1024 ^
  -b 1024 ^
  -np 1 ^
  --device ROCm0 ^
  --reasoning on ^
  --reasoning-format deepseek ^
  --jinja ^
  --chat-template-file "%CHAT_TEMPLATE_PATH%" ^
  --host 127.0.0.1 ^
  --port 8001