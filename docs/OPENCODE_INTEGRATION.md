# Opencode Integration

## Boundary

Do not put live `opencode` config in this repo.

This repo only provides example-only config shapes and mapping guidance. Your real `opencode.json` should remain in your existing external setup.

## Integration Principle

`opencode` should map logical roles to local endpoints.

Example role mapping:

- thinking -> `http://localhost:8000/v1`
- coding -> `http://localhost:8001/v1`
- research -> `http://localhost:8002/v1`

Keep the mapping stable and let each endpoint carry one role.

## Important llama.cpp Behavior

With `llama-server`, the endpoint decides which model is actually serving the request.

That means the `model` field in your orchestrator config is primarily a logical label unless you deliberately change what is loaded behind that endpoint.

## Critical Name-Matching Rule

When using `oh-my-openagent`, agent model names must exactly match model names exposed by `opencode` providers.

If names differ (short alias vs full gguf name), routing can silently fall back or bind to the wrong target.

Practical rule:

- pick one naming scheme
- use it in both `opencode.json` and `oh-my-openagent.json`
- avoid mixed-case or short-name variants unless both sides use the same value

## Config Pattern

Your external config should express:

- role name
- endpoint URL
- logical model alias
- temperature
- token budget
- optional fallback route

See the example files in [servers/opencode.single-endpoint.json.example](../servers/opencode.single-endpoint.json.example) and [servers/opencode.multi-endpoint.json.example](../servers/opencode.multi-endpoint.json.example).

## Recommended Starting Policy

1. Start with a multi-endpoint mapping if you already know you want dedicated roles.
2. Start with a single-endpoint mapping if you are still benchmarking models.
3. Keep aliases stable even if you swap underlying models, so the orchestrator logic does not churn.

## Tool-Calling Reliability

If a model narrates tool calls instead of executing them:

1. Start by selecting the correct model-specific chat template.
2. Check `llama.cpp/models/templates` first before inventing or reusing unrelated templates.
3. If multiple candidate templates exist, compare their tool-call formats and adapt for your exact model.
4. Add explicit agent instructions in `oh-my-openagent.json` using `prompt_append`.

In this setup, tool-calling was fixed by using the correct chat template for the model.

Practical workflow:

- inspect official templates in `llama.cpp/models/templates`
- feed the current prompt/output behavior and candidate template snippets to an LLM
- ask it to reconcile differences for the specific model you are serving
- keep the final instruction explicit so the model calls tools directly instead of narrating intent

Example instruction text:

"If a tool is needed, call it immediately. Do not describe or simulate tool calls in plain text."

This is especially important for planning-focused roles.

## Safety Rules

- do not commit personal paths if they belong in your external runtime config
- do not commit secrets
- do not let the repo become the source of truth for your live `opencode` state