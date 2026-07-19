# NestJS Service Template

Example authentication hexagon structure:

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
    auth.module.ts
  tests/
```

## Mapping

| NestJS concept | Constitutional area |
| --- | --- |
| `AuthModule` | `configuration` |
| Controller or request adapter | `adapters/drivers` |
| Cohesive application unit provider | `application` |
| Repository or external implementation | `adapters/drivens` |
| Repository or external contract | `ports/drivens` |

The example shows one driver and one driven for simplicity. A real controller or request adapter may represent a broader incoming purpose, such as a resource-oriented API, and initiate workflows that require multiple driven capabilities through application behavior.

Do not create one application use case per operation by default. Group related operations into one application unit when they belong to the same service capability, workflow, aggregate/resource responsibility, or transactional boundary. Split them only when rules, permissions, transactions, orchestration, side effects, or evolution/testing needs are meaningfully different.

## Composition Root

`configuration/auth.module.ts` assembles application units/use cases, adapters, port bindings, and configuration values.

It should contain service assembly, not domain behavior.
