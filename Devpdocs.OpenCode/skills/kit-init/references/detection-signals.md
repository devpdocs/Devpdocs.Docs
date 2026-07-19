# Detection Signals Reference

This document defines the signals `/kit-init` scans for during project
calibration. Each signal maps to one or more config.yaml fields.

## Signal Priority

Detection follows this priority chain (highest to lowest):

1. **Explicit configuration files** (lockfiles, manifest files)
2. **Directory structure** (convention-based paths)
3. **Tool configuration** (linter/formatter configs)
4. **CI/CD configuration** (pipeline definitions)
5. **Heuristics** (file extension counts, inference)

A signal detected at a higher priority overrides lower-priority inferences
for the same field.

## Project Identity

| Signal | Source | Maps To | Confidence |
| :--- | :--- | :--- | :--- |
| Git remote origin | `.git/config` | `project.name` | 0.90 |
| Directory basename | fallback | `project.name` | 0.60 |
| `package.json` `name` field | `package.json` | `project.name` | 0.85 |
| Root-level manifest presence | `.git/` | `project.root` | 1.00 |
| Project type inference | multiple signals | `project.type` | see below |

### Project Type Inference

| Conditions | Inferred Type | Confidence |
| :--- | :--- | :--- |
| Workspace config found (`pnpm-workspace.yaml`, `lerna.json`, `nx.json`, `turbo.json`) | `monorepo` | 0.85 |
| `packages/` + workspace config | `monorepo` | 0.90 |
| Exported binary/CLI entrypoint (`bin` field in `package.json`, `cmd/` in Go) | `application` | 0.80 |
| Only library exports, no binary | `library` | 0.75 |
| Dockerfile + service configs present | `service` | 0.80 |
| No clear signal | `unknown` | 0.50 |

## Technology Stack

### Languages and Runtimes

| Signal | Source | Language | Runtime | Confidence |
| :--- | :--- | :--- | :--- | :--- |
| `package.json` present | root | `typescript` or `javascript` | `node` or `bun` | 0.95 |
| `tsconfig.json` present | root or nested | `typescript` | — | 0.90 |
| `go.mod` present | root | `go` | — | 0.95 |
| `pyproject.toml` present | root | `python` | — | 0.90 |
| `Cargo.toml` present | root | `rust` | — | 0.95 |
| `Gemfile` present | root | `ruby` | — | 0.90 |
| `*.java` + `pom.xml` or `build.gradle` | src tree | `java` | `jvm` | 0.90 |
| `*.csproj` or `*.sln` present | src tree | `csharp` | `.net` | 0.90 |
| `composer.json` present | root | `php` | — | 0.90 |
| `CMakeLists.txt` present | root | `c` or `c++` | — | 0.80 |
| `*.swift` presence > 3 files | src tree | `swift` | — | 0.75 |
| `*.kt` presence > 3 files | src tree | `kotlin` | `jvm` | 0.75 |

### Package Managers

| Signal | Source | Manager | Confidence |
| :--- | :--- | :--- | :--- |
| `package-lock.json` | root | `npm` | 0.95 |
| `yarn.lock` | root | `yarn` | 0.95 |
| `pnpm-lock.yaml` | root | `pnpm` | 0.95 |
| `bun.lockb` | root | `bun` | 0.90 |
| `go.sum` | root | `go modules` | 0.95 |
| `poetry.lock` or `uv.lock` | root | `python (poetry/uv)` | 0.90 |
| `pipfile.lock` | root | `python (pipenv)` | 0.90 |
| `requirements.txt` | root | `python (pip)` | 0.85 |
| `Cargo.lock` | root | `cargo` | 0.95 |
| `Gemfile.lock` | root | `bundler` | 0.90 |
| `composer.lock` | root | `composer` | 0.90 |

### Frameworks

| Signal | Source | Framework | Confidence |
| :--- | :--- | :--- | :--- |
| `"next"` in `package.json` deps | `package.json` | `next.js` | 0.85 |
| `"react"` in `package.json` deps | `package.json` | `react` | 0.85 |
| `"vue"` in `package.json` deps | `package.json` | `vue` | 0.85 |
| `"svelte"` in `package.json` deps | `package.json` | `svelte` | 0.85 |
| `"express"` in `package.json` deps | `package.json` | `express` | 0.85 |
| `"fastify"` in `package.json` deps | `package.json` | `fastify` | 0.85 |
| `"django"` in `pyproject.toml` | `pyproject.toml` | `django` | 0.85 |
| `"flask"` in `pyproject.toml` | `pyproject.toml` | `flask` | 0.85 |
| `"fastapi"` in `pyproject.toml` | `pyproject.toml` | `fastapi` | 0.85 |
| `"actix-web"` in `Cargo.toml` | `Cargo.toml` | `actix-web` | 0.85 |
| `"axum"` in `Cargo.toml` | `Cargo.toml` | `axum` | 0.85 |
| `"rails"` in `Gemfile` | `Gemfile` | `rails` | 0.85 |
| `"gin"` in `go.mod` | `go.mod` | `gin` | 0.85 |
| `"echo"` in `go.mod` | `go.mod` | `echo` | 0.85 |

## Testing

### Test Commands

| Signal | Source | Command | Field | Confidence |
| :--- | :--- | :--- | :--- | :--- |
| `"test"` script in `package.json` | `package.json` | `npm test` or `yarn test` | `testing.commands.unit` | 0.90 |
| `"test:unit"` script | `package.json` | value of script | `testing.commands.unit` | 0.95 |
| `"test:integration"` script | `package.json` | value of script | `testing.commands.integration` | 0.90 |
| `"test:e2e"` script | `package.json` | value of script | `testing.commands.e2e` | 0.85 |
| `make test` target | `Makefile` | `make test` | `testing.commands.unit` | 0.85 |
| pytest config | `pytest.ini` or `pyproject.toml` `[tool.pytest]` | `pytest` or `python -m pytest` | `testing.commands.unit` | 0.85 |
| `make coverage` target | `Makefile` | value of target | `testing.capabilities.coverage_command` | 0.85 |
| `"coverage"` or `"test:coverage"` script | `package.json` | value of script | `testing.capabilities.coverage_command` | 0.85 |

### Test Capabilities

| Signal | Source | Capability | Confidence |
| :--- | :--- | :--- | :--- |
| `test/` directory exists and not empty | `test/` | `has_tests` | 0.80 |
| `tests/` directory exists and not empty | `tests/` | `has_tests` | 0.80 |
| `__tests__/` directory exists and not empty | `__tests__/` | `has_tests` | 0.80 |
| `*_test.go`, `*_spec.rb`, `*.test.ts`, `*.spec.ts` files present | scan | `has_tests` | 0.90 |
| `.github/workflows/*.yml` exists | `.github/workflows/` | `ci_detected` | 0.90 |
| `.gitlab-ci.yml` exists | `.gitlab-ci.yml` | `ci_detected` | 0.90 |
| `Jenkinsfile` exists | `Jenkinsfile` | `ci_detected` | 0.85 |
| `circle.yml` / `.circleci/config.yml` | `circle.yml` | `ci_detected` | 0.85 |

## Project Structure

| Signal | Path | Field | Confidence |
| :--- | :--- | :--- | :--- |
| `src/` directory | `src/` | `structure.key_paths.source` | 0.85 |
| `lib/` directory | `lib/` | `structure.key_paths.source` | 0.85 |
| `app/` directory | `app/` | `structure.key_paths.source` | 0.80 |
| `cmd/` directory (Go) | `cmd/` | `structure.key_paths.source` | 0.90 |
| `pkg/` directory (Go) | `pkg/` | `structure.key_paths.source` | 0.85 |
| `test/` directory | `test/` | `structure.key_paths.tests` | 0.85 |
| `tests/` directory | `tests/` | `structure.key_paths.tests` | 0.85 |
| `spec/` directory (Ruby) | `spec/` | `structure.key_paths.tests` | 0.85 |
| `docs/` directory | `docs/` | `structure.key_paths.docs` | 0.85 |
| `.opencode/` directory | `.opencode/` | `structure.key_paths.config` | 0.90 |
| Monorepo workspace indicators | `packages/`, workspace config | `structure.monorepo_packages` | 0.80 |

## Conventions

### Naming

| Signal | Source | Convention | Confidence |
| :--- | :--- | :--- | :--- |
| Majority of files use kebab-case | file scan | `kebab-case-files` | 0.70 |
| Majority of files use camelCase | file scan | `camelCase-files` | 0.70 |
| Majority of files use PascalCase | file scan | `PascalCase-files` | 0.70 |
| Majority of files use snake_case | file scan | `snake_case-files` | 0.70 |

### Linting

| Signal | Source | Tool | Confidence |
| :--- | :--- | :--- | :--- |
| `.eslintrc.*` or `eslint.config.*` | root | `eslint` | 0.90 |
| `.golangci.yml` | root | `golangci-lint` | 0.90 |
| `.rubocop.yml` | root | `rubocop` | 0.85 |
| `pylintrc` or `.pylintrc` | root | `pylint` | 0.85 |
| `ruff.toml` or `[tool.ruff]` in `pyproject.toml` | root | `ruff` | 0.85 |
| `clippy.toml` | root | `clippy` | 0.85 |
| `.phpcs.xml` | root | `phpcs` | 0.85 |
| `lint` script in `package.json` | `package.json` | `npm lint` | 0.80 |

### Formatting

| Signal | Source | Tool | Confidence |
| :--- | :--- | :--- | :--- |
| `.prettierrc.*` | root | `prettier` | 0.90 |
| `rustfmt.toml` | root | `rustfmt` | 0.85 |
| `.editorconfig` | root | `editorconfig` | 0.80 |
| `format` or `fmt` script in `package.json` | `package.json` | `npm format` | 0.75 |

## Architecture

### Style Detection

| Signal | Source | Style | Confidence |
| :--- | :--- | :--- | :--- |
| Clean architecture folders (`domain/`, `usecase/`, `infra/`, `interface/`) | tree | `hexagonal` | 0.65 |
| Layered folders (`controllers/`, `services/`, `repositories/`, `models/`) | tree | `layered` | 0.60 |
| Multiple independent services with own configs | tree | `microservices` | 0.70 |
| Single deployable with no sub-service separation | tree | `monolithic` | 0.60 |
| Event bus / message queue configs present | configs | `event-driven` | 0.60 |
| No recognizable pattern | — | `unknown` | 0.30 |

### Deployment Hints

| Signal | Source | Hint | Confidence |
| :--- | :--- | :--- | :--- |
| `Dockerfile` or `docker-compose.yml` | root | `docker` | 0.85 |
| `kubernetes/`, `k8s/`, `*.yaml` with `kind: Deployment` | tree | `kubernetes` | 0.80 |
| `terraform/` or `*.tf` files | tree | `terraform` | 0.85 |
| `helm/` or `Chart.yaml` | tree | `helm` | 0.80 |
| `fly.toml` | root | `fly.io` | 0.85 |
| `vercel.json` | root | `vercel` | 0.85 |
| `Procfile` | root | `heroku` | 0.80 |
| `.github/workflows/` with deploy steps | tree | `ci/cd deploy` | 0.75 |

## CI/CD

| Signal | Source | Description | Confidence |
| :--- | :--- | :--- | :--- |
| `.github/workflows/` directory | `.github/workflows/` | GitHub Actions | 0.90 |
| `.gitlab-ci.yml` | `.gitlab-ci.yml` | GitLab CI | 0.90 |
| `Jenkinsfile` | `Jenkinsfile` | Jenkins | 0.85 |
| `.circleci/config.yml` | `.circleci/` | CircleCI | 0.85 |
| `buildspec.yml` | root | AWS CodeBuild | 0.80 |
| `azure-pipelines.yml` | root | Azure Pipelines | 0.80 |
| `travis.yml` | root | Travis CI | 0.80 |

## Fallback Behavior

When no signal is found for a required field:

| Field | Fallback Value | Confidence |
| :--- | :--- | :--- |
| `project.name` | directory basename | 0.60 |
| `project.type` | `"unknown"` | 0.50 |
| `stack.languages` | `[]` (empty array) | 0.30 |
| `stack.package_managers` | `[]` (empty array) | 0.30 |
| `stack.runtimes` | `null` | 0.30 |
| `stack.frameworks` | `null` | 0.30 |
| `testing.commands.unit` | `null` | 0.30 |
| `testing.capabilities.has_tests` | `false` | 0.80 |
| `testing.capabilities.ci_detected` | `false` | 0.80 |
| `structure.key_paths.source` | `["."]` | 0.50 |
| `structure.key_paths.tests` | `null` | 0.50 |
| `structure.key_paths.docs` | `null` | 0.50 |
| `conventions.naming` | `null` | 0.30 |
| `conventions.linting` | `null` | 0.30 |
| `conventions.formatting` | `null` | 0.30 |
| `architecture.style` | `"unknown"` | 0.30 |
| `architecture.notes` | `[]` (empty array) | 1.00 |
| `architecture.deployment_hints` | `[]` (empty array) | 1.00 |

Every fallback must be recorded in `evidence` with `classification: assumption`
and a `path: null`.
