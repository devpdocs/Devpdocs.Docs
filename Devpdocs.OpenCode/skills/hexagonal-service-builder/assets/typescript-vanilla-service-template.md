# TypeScript Vanilla Service Template

Example authentication hexagon structure without a framework:

```text
auth/
  domain/
  application/
    managing-auth-use-case.ts
  ports/
    drivers/
      for-authenticating.ts
    drivens/
      for-control-authenticating.ts
  adapters/
    drivers/
      authenticator-proxy-adapter.ts
    drivens/
      control-authenticator-adapter.ts
      control-authenticator-stub-adapter.ts
  configuration/
    compose-auth.ts
  tests/
```

## Composition Root

`configuration/compose-auth.ts` assembles concrete adapters, application units/use cases, and configuration values.

This file is the service entry point for wiring, not the place for domain rules.

## Request Flow Example

```text
adapters/drivers/authenticator-proxy-adapter.ts
  -> application/managing-auth-use-case.ts
  -> ports/drivens/for-control-authenticating.ts
  -> adapters/drivens/control-authenticator-adapter.ts
```

This flow is intentionally small. A single driver adapter may represent a broader incoming purpose and initiate application behavior that requires multiple driven ports, with concrete assembly kept in `configuration`.

Application units are not created per operation by default. Group related operations into one application unit when they belong to the same cohesive service capability, workflow, aggregate/resource responsibility, or transactional boundary. Split them only for meaningful differences in rules, permissions, transactions, orchestration, side effects, or evolution/testing needs.
