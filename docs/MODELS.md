# Models

## Locked Role Lineup

This is the active lineup for this repo:

- Thinking: Qwen3.8-27B Q8_0 (hybrid linear/full attention, vision-capable, 262K native context)
- Coding: Qwen3.6-35B-A3B Q8_0
- Research: Qwen3.6-35B-A3B Q8_0

Thinking moved from Gemma 4 21B to Qwen3.8-27B for stronger reasoning, agentic, and vision performance while keeping coding/research on Qwen 3.6. Gemma 4 21B REAP Q6_K remains available via `launch-gemma4.cmd` as a fallback/faster option.

## Additional Models Available

You also have embedding and reranking models available in safetensors format. These are not directly compatible with llama.cpp but can be used with Ollama or Python-based services if you add those roles later:

- Qwen3-Embedding-4B (embedding service)
- Qwen3-Reranker-4B (reranking service)

## Research

### Primary

- Qwen3.6-35B-A3B-Q8_0.gguf

### Model Location

- C:\Models\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-Q8_0.gguf

### Why

- uses your newly available Qwen model
- keeps coding and research behavior in one model family
- strong text-focused synthesis and summarization

### Suggested Starting Quantization

- Q8_0 for highest local quality

## Coding

### Primary

- Qwen3.6-35B-A3B-Q8_0.gguf

### Model Location

- C:\Models\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-Q8_0.gguf

### Why

- dedicated coding model choice
- strong fit for deterministic patch-style work

### Practical Starting Point

- run this as the dedicated coding endpoint
- keep coding temperature low for consistent output

## Thinking

### Primary

- Qwen3.8-27B-Q8_0.gguf (+ mmproj-Qwen3.8-27B-BF16.gguf for vision)

### Model Location

- C:\Models\lmstudio-community\Qwen3.8-27B-GGUF\Qwen3.8-27B-Q8_0.gguf
- C:\Models\lmstudio-community\Qwen3.8-27B-GGUF\mmproj-Qwen3.8-27B-BF16.gguf

### Why

- Hybrid architecture (16x [3x Gated DeltaNet+FFN -> 1x Gated Attention+FFN]) keeps KV-cache cost low, so 128GB unified memory can run the full native 262,144 token context at Q8_0 with room to spare
- Vision-language support (image/video) via the bundled mmproj, useful for research and general queries
- Recommended sampling for thinking mode: `temp=1.0`, `top_p=0.95`, `top_k=20`, `min_p=0.0`, `presence_penalty=0.0`, `repetition_penalty=1.0` (baked into `launch-thinking.cmd` as server defaults)
- `reasoning_effort=xhigh` and `preserve_thinking=true` are set via `--chat-template-kwargs` to match Opus-like deep reasoning by default; drop to `medium`/`low` in that flag if latency matters more than depth
- `--parallel 1` dedicates the full context window to a single conversation instead of splitting it across slots

### Fallback Options

- gemma-4-21b-a4b-it-REAP-Q6_K.gguf via `launch-gemma4.cmd` - smaller/faster if you need to free memory or want lower latency planning
- gemma-4-E4B-it-OBLITERATED-Q8_0.gguf - larger Gemma 4 variant, kept as a quality fallback

## Recommended Adoption Order

1. Thinking: run Qwen3.8-27B on port 8000.
2. Coding: run Qwen 3.6 on port 8001.
3. Research: run Qwen 3.6 on port 8002.
4. Keep aliases stable in server launchers (`thinking`, `qwen3.6-coding`, `qwen3.6-research`).
5. Ensure orchestrator model names exactly match exposed server model names.

## Suggested Profiles

### Balanced (Recommended, current default)

- Research: Qwen3.6-35B-A3B-Q8_0
- Coding: Qwen3.6-35B-A3B-Q8_0
- Thinking: Qwen3.8-27B Q8_0 (strong reasoning/agentic/vision, full 262K context)

### Throughput First

- Research: Qwen3.6-35B-A3B-Q8_0
- Coding: Qwen3.6-35B-A3B-Q8_0
- Thinking: Gemma 4 21B Q6_K via `launch-gemma4.cmd` (fastest, lower quality)

## Model Selection Criteria

Choose the first-pass lineup based on:

- latency under realistic prompt sizes
- memory headroom while multiple servers are loaded
- output quality on your own tasks
- whether the role needs multimodal support

## Live Alias Map

Current launch scripts expose these aliases:

- Thinking: `thinking` (Qwen3.8-27B; `gemma-4` alias still available via `launch-gemma4.cmd`)
- Coding: `qwen3.6-coding`
- Research: `qwen3.6-research`

Use these aliases consistently in client or orchestrator config where practical.

## Getting New Models

When adding a new model, use this flow:

1. Find the model on Hugging Face.
2. Download it with the Hugging Face CLI (`hf`).

Example command used for Gemma 4 21B REAP Q6_K:

```powershell
hf download barozp/gemma-4-21b-a4b-it-REAP-GGUF --include "*Q6_K.gguf" --local-dir C:\Models\gemma-4-21b-a4b-it-REAP
```

## Future: Embedding and Reranking

When you decide to add embedding or reranking roles:

- **Qwen3-Embedding-4B**: Available at C:\Models\Qwen3-Embedding-4B (safetensors format, requires Ollama or Python service)
- **Qwen3-Reranker-4B**: Available at C:\Models\Qwen3-Reranker-4B (safetensors format, requires Ollama or Python service)

These models use the HuggingFace Transformers format instead of GGUF, so they cannot run directly on llama.cpp endpoints. Plan for these if you add embedding/reranking roles via a separate service layer like Ollama or FastEmbed.