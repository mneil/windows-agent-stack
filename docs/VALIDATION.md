# Validation

## Health Checks

For each running endpoint, verify `models` responds and aliases are as expected.

### PowerShell Example

```powershell
Invoke-RestMethod -Method Get -Uri http://localhost:8000/v1/models
Invoke-RestMethod -Method Get -Uri http://localhost:8001/v1/models
Invoke-RestMethod -Method Get -Uri http://localhost:8002/v1/models
```

Expected aliases:

- 8000: `gemma-4`
- 8001: `qwen3.6-coding`
- 8002: `qwen3.6-research`

## Role Checks

### Thinking

Goal: produce a usable plan for a medium-complexity task.

Pass criteria:

- decomposes the task into steps
- identifies dependencies or unknowns
- does not drift into code-heavy output unless asked
- executes tools when needed instead of narrating pseudo-calls

### Coding

Goal: produce deterministic implementation output.

Pass criteria:

- follows constraints accurately
- writes concrete code or patch-style output
- behaves consistently at low temperature

### Research

Goal: summarize and synthesize source material.

Pass criteria:

- extracts the important points without bloating
- compares options clearly
- remains concise and source-grounded

## End-To-End Flow

1. Thinking receives a task and produces a plan.
2. Research gathers or summarizes supporting material.
3. Coding produces implementation guidance or code.

Pass criteria:

- routing chooses the intended role
- each endpoint responds reliably
- output remains role-appropriate

## Operational Checks

Watch for:

- queueing under concurrent requests
- high memory pressure
- thermal throttling
- wrong model bound to a role endpoint
- too-small context windows for the task
- tool-call narration instead of tool execution

## Troubleshooting

### Wrong Model On Endpoint

If output quality looks wrong for a role, confirm you launched the expected model on the expected port.

### Port Conflicts

If a server fails to bind, check which process is using the port and move the endpoint if necessary.

### Research Quality Drops

If research compacts too often or loses detail, increase context and re-run the same evaluation prompts.

### Tool Calls Printed As Text

If output contains fake calls like `task(...)` as plain text:

1. Verify endpoint template is correct for the model.
2. Add explicit `prompt_append` instruction in orchestrator agent config to force direct tool invocation.
3. Re-run the same prompt and confirm tool invocation appears in runtime traces.

### Gemma Template Compatibility Warning

If startup logs show "detected an outdated gemma4 chat template":

1. Launch with an explicit official Gemma template file.
2. Restart server and verify warning is gone.

### Coding Is Too Loose

Lower the request temperature and reduce prompt ambiguity before changing models.