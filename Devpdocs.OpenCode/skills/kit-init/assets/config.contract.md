# config.yaml Field Contract v1

This document defines every field in `spec-kit.mini/config.yaml` — its
requirement level, type, nullability, and semantics. Use this as the
authoritative reference for generation and validation.

## Schema Root

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `schema_version` | yes | string | no | Semantic version of this contract. Must be `"1.0"`. |
| `generated_at` | yes | string (ISO 8601) | no | When this file was generated. |
| `project` | yes | object | no | Project identity block. |
| `stack` | yes | object | no | Technology stack block. |
| `testing` | yes | object | no | Testing setup block. |
| `structure` | yes | object | no | Project structure block. |
| `conventions` | yes | object | no | Convention and tooling block. |
| `architecture` | yes | object | no | Architecture hints block. |
| `rules_by_phase` | yes | object | no | Phase governance constraints. Must include all five phases. |
| `quality` | yes | object | no | Quality assessment block. |
| `evidence` | yes | array | no | Detection evidence log. Non-empty. |

## project

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `name` | yes | string | no | Project name from git remote or directory basename. |
| `root` | yes | string | no | Relative path to repository root. Always `"."` for single-repo. |
| `type` | yes | string | no | One of: `application`, `library`, `service`, `monorepo`, `unknown`. |

## stack

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `languages` | yes | string[] | no | Detected programming languages. Never null; empty array if undetected. |
| `runtimes` | yes | string[] | yes | Detected runtimes. Null if undetected. |
| `package_managers` | yes | string[] | no | Detected package managers. Never null; empty array if undetected. |
| `frameworks` | yes | string[] | yes | Detected frameworks. Null if undetected. |

## testing

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `commands.unit` | yes | string | yes | Unit test command. Null if undetected. |
| `commands.integration` | no | string | yes | Integration test command. |
| `commands.e2e` | no | string | yes | End-to-end test command. |
| `capabilities.has_tests` | yes | boolean | no | True if test directories or commands detected. |
| `capabilities.ci_detected` | yes | boolean | no | True if CI configuration files detected. |
| `capabilities.coverage_command` | no | string | yes | Coverage command if detected. |

## structure

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `key_paths.source` | yes | string[] | no | Source directories. Never null; empty array if undetected. |
| `key_paths.tests` | yes | string[] | yes | Test directories. Null if undetected. |
| `key_paths.docs` | yes | string[] | yes | Documentation directories. Null if undetected. |
| `key_paths.config` | no | string[] | yes | Governance/config directories (e.g. `.opencode/`). |
| `monorepo_packages` | no | string[] | yes | Package paths if monorepo. Null otherwise. |

## conventions

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `naming` | yes | string[] | yes | Detected naming conventions. Null if undetected. |
| `linting` | yes | string[] | yes | Detected linter tooling. Null if undetected. |
| `formatting` | yes | string[] | yes | Detected formatter tooling. Null if undetected. |

## architecture

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `style` | yes | string | no | One of: `layered`, `hexagonal`, `microservices`, `monolithic`, `event-driven`, `unknown`. |
| `notes` | yes | string[] | no | Architectural observations. Never null; empty array if none. |
| `deployment_hints` | yes | string[] | no | Deployment indicators (Dockerfile, k8s configs, etc.). Never null; empty array if none. |

## rules_by_phase

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `constitution.required` | yes | string[] | no | Required rules for constitution phase. |
| `specify.required` | yes | string[] | no | Required rules for specify phase. |
| `clarify.required` | yes | string[] | no | Required rules for clarify phase. |
| `approval.required` | yes | string[] | no | Required rules for approval phase. |
| `plan.required` | yes | string[] | no | Required rules for plan phase. |

Each phase must include at least one rule. The default ruleset is defined
in the skill SKILL.md and must not be altered by detection.

## quality

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `confidence` | yes | float | no | Aggregate confidence 0.0–1.0. Mean of all detection confidences. |
| `warnings` | yes | string[] | no | Human-readable warnings. Never null; empty array if none. |

## evidence (array items)

| Field | Required | Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `signal` | yes | string | no | Signal type: filename, directory, config key, or `"heuristic"`. |
| `path` | yes | string | yes | Filesystem path to the signal. Null for heuristics. |
| `confidence` | yes | float | no | Confidence of this individual detection (0.0–1.0). |
| `classification` | yes | string | no | `fact` (unambiguous) or `assumption` (best-guess inference). |
| `detected` | yes | string[] | no | List of config paths this signal contributed to (dot-notation). |

## Validation Rules

1. All required fields must be present and non-null.
2. `schema_version` must be `"1.0"`.
3. `generated_at` must be valid ISO 8601.
4. `project.type` must be one of the allowed enum values.
5. `architecture.style` must be one of the allowed enum values.
6. `quality.confidence` must be between 0.0 and 1.0 inclusive.
7. `evidence` must contain at least one entry.
8. Every `evidence[x].classification` must be `fact` or `assumption`.
9. Every `evidence[x].confidence` must be between 0.0 and 1.0 inclusive.
10. `rules_by_phase` must include all five phase keys.
