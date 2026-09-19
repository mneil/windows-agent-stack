@echo off
set "MODEL_PATH=C:\Models\unsloth\Qwen3.8-27B-GGUF\Qwen3.8-27B-UD-Q4_K_M.gguf"
set "MMPROJ_PATH=C:\Models\unsloth\Qwen3.8-27B-GGUF\mmproj-F16.gguf"
set "DRAFT_MODEL=C:\Models\unsloth\Qwen3.8-27B-GGUF\mtp-Qwen3.8-27B-Q4_0.gguf"
if "%LLAMA_SERVER_EXE%"=="" set LLAMA_SERVER_EXE=llama-server.exe

set AMD_GPU_WAVE_SIZE=64
set HIP_VISIBLE_DEVICES=0
set HSA_ENABLE_SDMA=1

"%LLAMA_SERVER_EXE%" ^
  -m "%MODEL_PATH%" ^
  --verbosity 4 ^
  --mmproj "%MMPROJ_PATH%" ^
  --spec-draft-model "%DRAFT_MODEL%" ^
  --spec-type draft-mtp ^
  --spec-draft-n-max 3 ^
  --flash-attn on ^
  --threads 12 ^
  --alias qwen3.8 ^
  --ctx-size 262141 ^
  --n-gpu-layers 999 ^
  --ubatch-size 512 ^
  --batch-size 512 ^
  --load-mode none ^
  --parallel 3 ^
  --cache-prompt ^
  --cache-ram "0" ^
  --cache-type-k q8_0 ^
  --cache-type-v q8_0 ^
  --ctx-checkpoints 4 ^
  --checkpoint-min-step 4096 ^
  --reasoning on ^
  --reasoning-format auto ^
  --chat-template-kwargs "{\"reasoning_effort\":\"xhigh\",\"preserve_thinking\":true}" ^
  --temp 1 ^
  --top-p 0.95 ^
  --top-k 20 ^
  --min-p 0.05 ^
  --repeat-penalty 1.1 ^
  --sleep-idle-seconds "3600" ^
  --jinja ^
  --device ROCm0 ^
  --host 127.0.0.1 ^
  --port 8000