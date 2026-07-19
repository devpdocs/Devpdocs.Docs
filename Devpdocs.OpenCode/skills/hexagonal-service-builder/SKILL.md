---
name: hexagonal-service-builder
description: >
  Builds or reviews a service/hexagon using the project constitution for structure,
  boundaries, composition, ports, adapters, and file nomenclature.
  Trigger: Use when creating, extending, or reviewing a TypeScript/NestJS or
  TypeScript vanilla service that follows the hexagonal architecture constitution.
license: Apache-2.0
metadata:
  author: Moisés Buenaño Tuberquia
  version: "1.0"
---

## When to Use

- Use when creating a new service/hexagon from scratch.
- Use when adding ports, adapters, use cases, or composition files to an existing service.
- Use when reviewing whether a service follows the hexagonal constitution.
- Use when generating TypeScript/NestJS or TypeScript vanilla service structure.
- Use when adapting the same concepts to another language while preserving the constitutional rules.

## Critical Patterns

- A service is a bounded unit with domain concepts, application behavior, ports, adapters, configuration, and tests.
- The canonical structure is mandatory unless the user explicitly defines a different scope.
- `configuration` is the Composition Root and owns service assembly.
- `ports/drivers` is an independent contract area.
- `adapters/drivers` may reference application units/use cases directly.
- `adapters/drivens` fulfill driven contracts.
- Composition involving multiple concrete adapters belongs in `configuration`.
- Create driver-side adapters by incoming purpose or invocation role, not by the number of driven capabilities involved.
- A single driver-side adapter may initiate behavior that requires multiple driven ports through application behavior and composition.
- Create application units by cohesive service capability, workflow, aggregate/resource responsibility, or transactional boundary; do not create one use case per operation by default.
- Multiple operations may belong to one application unit when they share the same service responsibility, rules, dependencies, and lifecycle.
- Split application units only when workflows have meaningfully different rules, permissions, transactions, orchestration, side effects, or evolution/testing needs.
- File names must use lowercase kebab-case; uppercase letters are invalid.
- Extra suffixes before the implementation extension are not allowed.

## Canonical Service Structure

```text
<service>/
  domain/
  application/
  ports/
    drivers/
    drivens/
  adapters/
    drivers/
    drivens/
  configuration/
  tests/
```

## Responsibility Boundaries

| Area | Responsibility |
| --- | --- |
| `domain` | Central concepts, rules, and vocabulary. |
| `application` | Cohesive service capabilities, workflows, and service behavior. |
| `ports/drivers` | Contracts for requests entering the service. |
| `ports/drivens` | Contracts for capabilities required by the service. |
| `adapters/drivers` | Mechanisms that initiate service behavior. |
| `adapters/drivens` | Mechanisms used to reach external capabilities. |
| `configuration` | Composition Root and service assembly. |
| `tests` | Service-level evidence for behavior and boundaries. |

## Dependency Rules

- `domain` must not reference application, ports, adapters, configuration, or tests.
- `application` may reference domain elements and port contracts.
- `ports` must not reference concrete adapters.
- `adapters/drivers` may reference application units/use cases directly.
- `adapters/drivens` may reference driven port contracts.
- `configuration` may reference concrete parts to assemble the service.
- `tests` may reference any area needed to provide evidence.

## Ports and Adapters Naming

| Location | Required pattern |
| --- | --- |
| `ports/drivens` | `for-<service>-<action>.<extension>` |
| `ports/drivers` | `for-<action>.<extension>` |
| `adapters/drivens` | `<service>-<role>-adapter.<extension>` |
| `adapters/drivens` | `<service>-<role>-stub-adapter.<extension>` |
| `adapters/drivers` | `<role>-proxy-adapter.<extension>` |

## Naming Validation

- `<service>`, `<action>`, and `<role>` are variable terms, not fixed vocabulary.
- Use lowercase kebab-case terms.
- Report uppercase letters as invalid; do not normalize before validation.
- Allow equivalent implementation extensions when they match the service language or tooling.
- Do not allow extra suffixes before the extension, such as `.interface` or `.provider`.
- Stub adapter files are valid only under `adapters/drivens`.
- Proxy adapter files are valid only under `adapters/drivers`.
- Do not require a one-to-one correspondence between driver-side and driven-side files.

## TypeScript/NestJS Guidance

- Treat the NestJS module for the service as the Composition Root.
- Place the module under `configuration`, for example `auth/configuration/auth.module.ts`.
- Place controllers under `adapters/drivers`.
- Place repository, token, hashing, or external service implementations under `adapters/drivens`.
- Keep application units/use cases under `application`.
- Keep contracts under `ports/drivers` or `ports/drivens` according to direction.

## TypeScript Vanilla Guidance

- Use an explicit composition file under `configuration`, such as `compose-auth.ts`.
- Compose application units/use cases, adapters, and configuration values in that file.
- Keep framework-free request handlers or CLI handlers under `adapters/drivers`.
- Keep external implementations under `adapters/drivens`.

## Conceptual Support for Other Languages

- Preserve the canonical areas and responsibility boundaries.
- Replace `<extension>` with the accepted extension for the project language or tooling.
- Keep the file stem aligned with the naming rule even when the extension changes.

## Build Checklist

- Create the canonical directory structure.
- Add domain concepts without outward dependencies.
- Add application units grouped by cohesive service capability, workflow, aggregate/resource responsibility, or transactional boundary; do not default to one use case per operation.
- Add driver ports/adapters for incoming purposes using the required naming patterns.
- Add driven ports/adapters for required capabilities using the required naming patterns.
- Add the Composition Root under `configuration`.
- Add service-level tests under `tests`.
- Review names for lowercase kebab-case and invalid suffixes.

## Resources

- **Service Tree Template**: See [assets/service-tree-template.md](assets/service-tree-template.md).
- **NestJS Template**: See [assets/nestjs-service-template.md](assets/nestjs-service-template.md).
- **TypeScript Vanilla Template**: See [assets/typescript-vanilla-service-template.md](assets/typescript-vanilla-service-template.md).
- **Naming Rules**: See [assets/naming-rules.md](assets/naming-rules.md).
