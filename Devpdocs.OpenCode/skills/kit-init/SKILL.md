---
name: kit-init
description: >
  Initializes a project for the spec-kit.mini workflow by detecting and
  serializing stack, testing, structure, and convention definitions into
  the canonical handoff file spec-kit.mini/config.yaml.
  Trigger: Use ONLY when the user or orchestrator needs to calibrate or
  recalibrate a project with /kit-init, wants to detect project context,
  generate spec-kit.mini/config.yaml, or set up the project baseline for
  the SDD workflow.
license: Apache-2.0
metadata:
  author: Moisés Buenaño Tuberquia
  version: "1.0"
---

## When to Use

Use this skill when:
- a project needs initial calibration for the spec-kit.mini workflow
- `spec-kit.mini/config.yaml` is missing or must be regenerated
- the orchestrator requests a fresh project context snapshot
- project structure, stack, or testing setup has changed and the context must be refreshed
- the user invokes `/kit-init` or asks to "calibrate", "initialize context", or "detect project"

Do not use this skill for:
- specification work (delegate to `spec-kit.mini`)
- orchestration or phase routing (delegate to the orchestrator)
- feature-level decisions or acceptance criteria
- implementation planning or code generation

## Required Inputs

Before starting, verify:
- a repository root is accessible
- the skill has permission to read the entire repository
- the skill has permission to write to `spec-kit.mini/config.yaml`

## Output Contract

This skill produces exactly one artifact:

**`spec-kit.mini/config.yaml`** — the canonical project definitions file consumed by the orchestrator.

Key rules:
- always write to exactly `spec-kit.mini/config.yaml` at the repository root
- always fully rewrite the file on every run (no merge, no patch, no preserve)
- never block on file age or commit freshness; validity is schema/content based only
- always include `schema_version` as the first field
- always separate **facts** (detected signals) from **assumptions** (inferred defaults)

## Workflow

### Phase 1 — Signal Collection

Scan the repository for detection signals. Authoritative reference:
`.opencode/skills/kit-init/references/detection-signals.md`

Collect the following categories:

| Category | Signals |
| :--- | :--- |
| Project identity | `package.json`, `go.mod`, `pyproject.toml`, `Cargo.toml`, `Gemfile`, `.git/config` |
| Stack | language runtimes, package managers, frameworks from lockfiles and configs |
| Testing | test commands in `package.json` scripts, `Makefile`, CI configs, test directory presence |
| Structure | `src/`, `lib/`, `test/`, `docs/`, `cmd/`, `pkg/` directories |
| Conventions | linter configs (`.eslintrc`, `.golangci.yml`, `.rubocop.yml`), formatters (`.prettierrc`, `rustfmt.toml`) |
| Architecture | monorepo indicators, workspace files, Dockerfiles, deployment configs |
| CI/CD | `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `circle.yml` |
| Governance | existing `.opencode/` configs, `AGENTS.md`, constitution files |

### Phase 2 — Detection and Classification

For each detected signal:
1. record the **path** and **signal type** in the evidence block
2. classify as **fact** (unambiguous detection) or **assumption** (best-guess inference)
3. assign a **confidence** score to each detection (0.0–1.0)
4. accumulate **warnings** for missing or uncertain signals

### Phase 3 — Serialization

Assemble the YAML output following the canonical template. Authoritative reference:
`.opencode/skills/kit-init/assets/config.template.yaml`

Field contract (required vs optional, nullability, semantics). Authoritative reference:
`.opencode/skills/kit-init/assets/config.contract.md`

Output rules:
- `schema_version` must always be present as the first field
- every non-trivial detection must appear in `evidence`
- missing data must use explicit `null` or `warnings`, never silent omission
- `rules_by_phase` must include the default phase constraints defined below
- `quality.confidence` must be a computed aggregate of all detection confidences
- `quality.warnings` must list every missing or low-confidence signal

### Phase 4 — Validation

Before writing, validate:
- all required keys are present (see contract)
- `schema_version` is present and parseable
- `generated_at` is a valid ISO 8601 timestamp
- `quality.confidence` is between 0.0 and 1.0
- `evidence` is a non-empty array
- no YAML syntax errors

### Phase 5 — Write

Write the assembled YAML to `spec-kit.mini/config.yaml` at the repository root.
Create the `spec-kit.mini/` directory if it does not exist.

## Default rules_by_phase

The following phase rules are always included and must not be altered by
detection. These are inherited from spec-kit.mini governance:

```yaml
rules_by_phase:
  constitution:
    required:
      - explicit approval
      - governing principles
      - decision rules
  specify:
    required:
      - facts vs assumptions separation
      - unresolved items carried forward
      - no premature ambiguity resolution
  clarify:
    required:
      - resolve open questions
      - challenge assumptions
      - define acceptance criteria
  approval:
    required:
      - explicit signoff
      - rejection reasons when applicable
      - constitution alignment check
  plan:
    required:
      - ordered to-do list
      - no new scope
      - validation tasks tied to acceptance criteria
```

## Quality Assessment

Compute `quality.confidence` as the arithmetic mean of all detection confidences
(including inferred defaults at 0.5). Produce `quality.warnings` for:
- no test command detected
- no CI configuration found
- no linter configuration found
- no formatter configuration found
- monorepo indicators present but not confirmed
- any detection confidence below 0.7

## Working Rules

- output is always `spec-kit.mini/config.yaml`, fully rewritten
- output must be valid YAML
- output must validate against the contract before writing
- missing signals are explicit (null + warning), not silent
- assumptions must be labeled, not passed as facts
- evidence must be traceable to a concrete file or signal
- idempotent: same repository state produces same output
- deterministic: field order is stable across runs
- file age or commit freshness is irrelevant; do not reject or warn based on age
- do not perform specification, clarification, approval, or planning work
- do not make architectural recommendations or product decisions
- do not modify any file other than `spec-kit.mini/config.yaml`

## Commands

```bash
# (No shell commands required — detection is performed via file reads)
```

## Resources

- **Template**: See [assets/config.template.yaml](assets/config.template.yaml) for the canonical YAML shape
- **Contract**: See [assets/config.contract.md](assets/config.contract.md) for field-by-field semantics
- **Signals**: See [references/detection-signals.md](references/detection-signals.md) for detection patterns
