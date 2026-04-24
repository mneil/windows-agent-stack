@echo off
set MODEL_PATH=C:\Models\gemma-4-21b-a4b-it-REAP\gemma-4-21b-a4b-it-REAP-Q6_K.gguf
set CHAT_TEMPLATE_PATH=%~dp0tool_chat_template_google-gemma-4-31B-it.jinja
if "%LLAMA_SERVER_EXE%"=="" set LLAMA_SERVER_EXE=llama-server.exe

"%LLAMA_SERVER_EXE%" ^
  -m "%MODEL_PATH%" ^
  -a gemma-4 ^
  -c 65536 ^
  -ngl all ^
  -fa auto ^
  -ctk q8_0 ^
  -ctv q8_0 ^
  -ub 512 ^
  -b 512 ^
  -np 1 ^
  --device ROCm0 ^
  --reasoning on ^
  --reasoning-format deepseek ^
  --jinja ^
  --chat-template-file "%CHAT_TEMPLATE_PATH%" ^
  --host 127.0.0.1 ^
  --port 8000