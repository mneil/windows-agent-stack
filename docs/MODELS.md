# Models

## Locked Role Lineup

This is the active lineup for this repo:

- Thinking: Gemma 4 21B REAP Q6_K
- Coding: Qwen3.6-35B-A3B Q8_0
- Research: Qwen3.6-35B-A3B Q8_0

This keeps coding and research on Qwen while using Gemma 4 for thinking.

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

### Primary Options

Option A: Faster (current baseline)
- gemma-4-21b-a4b-it-REAP-Q6_K.gguf
- Model Location: C:\Models\gemma-4-21b-a4b-it-REAP\gemma-4-21b-a4b-it-REAP-Q6_K.gguf
- Benefit: 21B is smaller, lower latency for planning tasks

Option B: Higher quality
- gemma-4-E4B-it-OBLITERATED-Q8_0.gguf
- gemma-4-E4B-it-OBLITERATED-mmproj-f16.gguf
- Model Location: C:\Models\gemma-4-E4B-it-OBLITERATED\
- Benefit: Larger model, stronger reasoning if latency is acceptable

### Why

- Gemma 4 gives strong reasoning and context handling for plan-first workflows
- Both variants are proven in your environment
- Start with 21B for faster planning, upgrade to E4B if quality is insufficient

## Recommended Adoption Order

1. Thinking: run Gemma 4 21B on port 8000.
2. Coding: run Qwen 3.6 on port 8001.
3. Research: run Qwen 3.6 on port 8002.
4. Keep aliases stable in server launchers (`gemma-4`, `qwen3.6-coding`, `qwen3.6-research`).
5. Ensure orchestrator model names exactly match exposed server model names.

## Suggested Profiles

### Balanced (Recommended)

- Research: Qwen3.6-35B-A3B-Q8_0
- Coding: Qwen3.6-35B-A3B-Q8_0
- Thinking: Gemma 4 21B Q6_K (faster planning, current default)

### Quality First

- Research: Qwen3.6-35B-A3B-Q8_0
- Coding: Qwen3.6-35B-A3B-Q8_0
- Thinking: Gemma 4 E4B Q8_0 (slower but higher quality)

### Throughput First

- Research: Qwen3.6-35B-A3B-Q8_0
- Coding: Qwen3.6-35B-A3B-Q8_0
- Thinking: Gemma 4 21B Q6_K (fastest option)

## Model Selection Criteria

Choose the first-pass lineup based on:

- latency under realistic prompt sizes
- memory headroom while multiple servers are loaded
- output quality on your own tasks
- whether the role needs multimodal support

## Live Alias Map

Current launch scripts expose these aliases:

- Thinking: `gemma-4`
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