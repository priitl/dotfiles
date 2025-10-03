# Tech Stack: Spring Boot & Hexagonal Architecture

## Overview
Spring Boot projects following hexagonal (ports and adapters) architecture with clean separation between domain logic and infrastructure concerns.

## Architecture Patterns

### Hexagonal Architecture (Ports & Adapters)
- **Domain layer**: Pure business logic without external dependencies
- **Ports**: Interfaces defining contracts between layers
  - Inbound ports: Use case interfaces (what the application does)
  - Outbound ports: Repository/external service interfaces (what the application needs)
- **Adapters**: Implementations connecting to external systems
  - Inbound adapters: REST controllers, message listeners
  - Outbound adapters: Database repositories, external API clients
- **Application layer**: Spring Boot configuration and dependency wiring

### Typical Module Structure
```
project-root/
├── domain/
│   ├── api/                    # Public interfaces and domain models
│   │   └── src/main/java/     # Use case interfaces, domain records
│   ├── impl/                   # Use case implementations
│   │   └── src/main/java/     # Business logic (@Component classes)
│   └── ports/                  # Repository/external service interfaces
│       └── src/main/java/     # Port interfaces
├── adapter/
│   ├── web/                    # REST controllers
│   ├── database/               # Database persistence (Spring Data JDBC)
│   ├── database-migration/     # Liquibase migrations
│   └── [other-adapters]/       # External API clients, messaging, etc.
└── application/                # Spring Boot application
    └── src/main/
        ├── java/               # Main class, @Configuration classes
        └── resources/          # application.yml, etc.
```

## Java Conventions

### Modern Java Idioms
- **Use `var`** for local variables when type is obvious
- **Use records** for immutable DTOs and value objects
- **Use `String.formatted()`** instead of concatenation
- **Use Optional chains** (`.map()`, `.orElse()`) over if-else blocks
- **Inject `Clock`** for all time operations (no direct `.now()` calls)

### Lombok Usage
- `@Builder` for object construction (domain models, test data)
- `@RequiredArgsConstructor` for dependency injection in Spring components
- `@Getter` for generating getter methods (prefer class-level)

### Naming Conventions
- **Use case interfaces**: Verb-based names (e.g., `PlaceOrder`, `GetOrderById`)
- **Port interfaces**: Descriptive names ending in `Port` (e.g., `SaveOrderPort`, `NotifyOrderPlacedPort`)
- **Implementations**: Interface name + `Impl` suffix (e.g., `PlaceOrderImpl`)
- **Avoid**: "improved", "new", "enhanced" (code should be evergreen)

## Component Patterns

### Use Case Interface (Function-based)
```java
package com.example.orders;

import java.util.UUID;
import java.util.function.Function;
import lombok.Builder;

public interface PlaceOrder extends Function<PlaceOrder.Request, UUID> {

    @Builder
    record Request(
        @NotNull String customerId,
        @NotEmpty List<OrderItem> items
    ) {}
}
```

### Use Case Implementation
```java
package com.example.orders;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.time.Clock;
import java.time.Instant;

@Component
@RequiredArgsConstructor
class PlaceOrderImpl implements PlaceOrder {

    private final SaveOrderPort saveOrderPort;
    private final InventoryCheckPort inventoryCheckPort;
    private final Clock clock;

    @Override
    public UUID apply(Request request) {
        // Business logic implementation
        var orderId = UUID.randomUUID();
        var order = Order.builder()
            .orderId(orderId)
            .customerId(request.customerId())
            .placedAt(Instant.now(clock))
            .build();

        return saveOrderPort.apply(order).orderId();
    }
}
```

### Outbound Port (Function-based)
```java
package com.example.orders;

import java.util.function.Function;

public interface SaveOrderPort extends Function<Order, Order> {
}
```

### REST Controller (Inbound Adapter)
```java
package com.example.orders;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
class OrderController {

    private final PlaceOrder placeOrder;

    @PostMapping
    public ResponseEntity<OrderResponse> createOrder(
        @Valid @RequestBody PlaceOrder.Request request
    ) {
        var orderId = placeOrder.apply(request);
        return ResponseEntity.ok(new OrderResponse(orderId));
    }

    record OrderResponse(UUID orderId) {}
}
```

### Repository Adapter (Outbound Adapter)
```java
package com.example.orders;

import lombok.RequiredArgsConstructor;
import org.springframework.data.jdbc.core.JdbcAggregateTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
class OrderRepository implements SaveOrderPort {

    private final JdbcAggregateTemplate jdbcTemplate;

    @Override
    public Order apply(Order order) {
        return jdbcTemplate.save(order);
    }
}
```

## Testing Strategy

### Test Pyramid
1. **Unit Tests**: Domain logic in isolation (use cases, domain services)
2. **Integration Tests**: Cross-layer flows with real database (Testcontainers)
3. **End-to-End Tests**: Full API flows through REST controllers

### Unit Test Pattern
```java
@ExtendWith(MockitoExtension.class)
class PlaceOrderImplTest {

    @Mock private SaveOrderPort saveOrderPort;
    @Mock private InventoryCheckPort inventoryCheckPort;

    private Clock clock;
    private PlaceOrderImpl useCase;

    @BeforeEach
    void setUp() {
        clock = Clock.fixed(Instant.parse("2025-01-15T10:00:00Z"), ZoneId.of("UTC"));
        useCase = new PlaceOrderImpl(saveOrderPort, inventoryCheckPort, clock);
    }

    @Test
    void shouldPlaceOrderWhenInventoryAvailable() {
        // Arrange, Act, Assert
    }
}
```

### Integration Test Pattern
```java
@SpringBootTest
@ActiveProfiles("integration-test")
@Testcontainers
class PlaceOrderIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired
    private PlaceOrder placeOrder;

    @Test
    void shouldPersistOrderToDatabase() {
        // Test cross-layer integration
    }
}
```

### Testing Tools
- **JUnit 5**: Test framework
- **Mockito**: Mocking for unit tests
- **AssertJ**: Fluent assertions
- **Testcontainers**: Real database for integration tests
- **Spring Boot Test**: Application context for integration tests

## Database Patterns

### Liquibase Migrations
- Location: `adapter/database-migration/src/main/resources/changelog/`
- Naming: `YYYYMMDD-HHMM-description.xml` or `.sql`
- Versioned, reversible migrations

### Spring Data JDBC
- Aggregate-oriented persistence
- No lazy loading (explicit loading)
- Immutable domain models with `@Builder(toBuilder = true)`

## Configuration Patterns

### Clock Bean (for testable time)
```java
@Configuration
public class ClockConfig {

    @Bean
    public Clock clock() {
        return Clock.system(ZoneId.of("UTC"));
    }
}
```

### Dependency Wiring
```java
@Configuration
public class DomainConfig {

    @Bean
    public PlaceOrder placeOrder(
        SaveOrderPort saveOrderPort,
        InventoryCheckPort inventoryCheckPort,
        Clock clock
    ) {
        return new PlaceOrderImpl(saveOrderPort, inventoryCheckPort, clock);
    }
}
```

## Code Quality Standards

### Required Practices
- **Test-first development**: Write tests before implementation
- **Inject Clock**: Never use direct `.now()` calls
- **Use records**: For DTOs and immutable value objects
- **No Spring in domain**: Domain layer must be framework-agnostic
- **Files end with newline**: POSIX compliance
- **TODO comments**: For mock implementations

### Forbidden Practices
- ❌ Direct `.now()` calls (use injected `Clock`)
- ❌ Spring annotations in domain layer
- ❌ Domain depending on adapters
- ❌ Temporal language in comments ("recently", "new")
- ❌ Skipping tests

## Common Components

### Typical Use Cases
- Create/update entity (e.g., `PlaceOrder`, `UpdateOrderStatus`)
- Query entity (e.g., `GetOrderById`, `FindOrdersByCustomer`)
- Business validation (e.g., `ValidateInventory`)
- External notifications (e.g., `NotifyOrderPlaced`)

### Typical Ports
- **Inbound**: Use case interfaces (what application does)
- **Outbound**:
  - `Save{Entity}Port`: Persistence
  - `Get{Entity}Port`: Retrieval
  - `Notify{Event}Port`: Notifications
  - `Check{Condition}Port`: External validations

### Typical Adapters
- **Web**: REST controllers with `@RestController`
- **Database**: Repositories with Spring Data JDBC
- **External APIs**: HTTP clients (RestTemplate, WebClient)
- **Messaging**: Kafka/RabbitMQ listeners/publishers

## Planning Considerations

### When Planning Spring Boot Features
1. **Domain Layer**: Identify use cases and domain models
2. **Ports**: Define contracts (inbound for API, outbound for persistence/external)
3. **Adapters**: Plan REST endpoints, database repositories, external integrations
4. **Database**: Schema changes, Liquibase migrations
5. **Testing**: Unit tests for domain, integration tests for flows, e2e for APIs
6. **Configuration**: Bean wiring, application properties

### Task Breakdown Pattern
1. **T1-T3**: Database schema and migration
2. **T4-T7**: Domain layer (models, use cases, unit tests)
3. **T8-T10**: Outbound adapters (repositories, external clients)
4. **T11-T13**: Inbound adapters (REST controllers)
5. **T14-T16**: Integration tests
6. **T17-T18**: End-to-end tests
7. **T19**: Configuration and wiring

## References
- Spring Boot: https://spring.io/projects/spring-boot
- Hexagonal Architecture: https://alistair.cockburn.us/hexagonal-architecture/
- Spring Data JDBC: https://spring.io/projects/spring-data-jdbc
- Testcontainers: https://testcontainers.com/
