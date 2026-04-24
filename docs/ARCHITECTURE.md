# Architecture

## Roles

### Thinking

Use this role for:

- planning
- decomposition
- architecture choices
- fallback reasoning when a task needs broader synthesis

This role should be the coordinator, not the default implementation model.

### Coding

Use this role for:

- code generation
- patch creation
- refactors
- debugging
- test-oriented implementation

This role should be low temperature and biased toward consistency.

### Research

Use this role for:

- summarization
- document digestion
- comparison of alternatives
- context gathering before implementation

Current baseline keeps research text-focused on Qwen 3.6.

## Default Routing

1. Thinking receives the initial problem and decides whether research is needed.
2. Research gathers context, summarizes sources, or interprets multimodal input.
3. Coding implements the result.
4. Thinking optionally reviews the final approach when the task is high impact.

## Fallback Rules

- If thinking is unavailable, research can do triage and summary, but should not become the primary coding model.
- If coding is unavailable, thinking can draft implementation guidance, but expect weaker code quality.
- If research is unavailable, thinking can do light synthesis, but multimodal coverage drops.

## Topologies

### Dedicated Three-Endpoint Setup

- Thinking on `http://localhost:8000/v1` (Gemma 4, alias `gemma-4`)
- Coding on `http://localhost:8001/v1` (Qwen 3.6, alias `qwen3.6-coding`)
- Research on `http://localhost:8002/v1` (Qwen 3.6, alias `qwen3.6-research`)

This is the preferred shape once all three roles are active.

### Two-Endpoint Setup

- Thinking and research share one endpoint.
- Coding gets its own endpoint.

Use this if you want lower memory pressure while still keeping coding specialized.

### Single-Endpoint Setup

- One endpoint serves every role.

Use this only for early testing or if you want to prove the orchestration layer before loading multiple models.

## Practical Guidance For 128 GB RAM

- Keep role boundaries strict even when models overlap.
- Treat endpoint routing as source-of-truth, not model labels in prompts.
- If long tasks compact too aggressively, raise context on the busiest endpoint first.
- Keep coding and research on separate templates even if they use the same base model.

The best topology is the one that keeps latency, thermal behavior, and queueing acceptable under your actual agent workload.