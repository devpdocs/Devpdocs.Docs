# Service Tree Template

Use this tree when creating a new service/hexagon.

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

## Area Summary

| Area | Purpose |
| --- | --- |
| `domain` | Central concepts, rules, and vocabulary. |
| `application` | Cohesive service capabilities, workflows, and service behavior. |
| `ports/drivers` | Contracts for incoming service requests. |
| `ports/drivens` | Contracts for required external capabilities. |
| `adapters/drivers` | Mechanisms that initiate service behavior. |
| `adapters/drivens` | Mechanisms that provide external capabilities. |
| `configuration` | Composition Root and service assembly. |
| `tests` | Service-level behavior and boundary evidence. |

Driver-side areas represent incoming purposes or invocation roles. They are not required to mirror driven-side capabilities one-to-one.

Application units are not required to mirror individual operations one-to-one. Group behavior by cohesive service capability, workflow, aggregate/resource responsibility, or transactional boundary, and split only when rules, permissions, orchestration, side effects, or evolution/testing needs are meaningfully different.
