<!--
Constitution Version: 1.0.0 (initial ratification)
Modified Principles: N/A (new constitution)
Added Sections: All (initial creation)
Removed Sections: N/A
Templates Requiring Updates: N/A (new constitution)
Follow-up TODOs: None
-->

# FujitsuTrialTask Project Constitution

**Version:** 1.0.0
**Ratified:** 2025-01-04
**Last Amended:** 2025-01-04

---

## Preamble

We, the developers of **FujitsuTrialTask**, establish this Constitution to define the fundamental principles, technical guidelines, and governance structure that SHALL guide all development activities. This document serves as the foundational contract between team members, ensuring consistency, quality, and maintainability of the food delivery fee calculation system with weather-based pricing.

This Constitution applies to all code, documentation, configuration, and artifacts within the project repository. All contributors MUST adhere to these principles, and any deviation requires explicit justification and approval through the amendment process.

---

## Article I: Testing & Quality Assurance

### Principle 1.1: Comprehensive Test Coverage
**Statement:** All business logic MUST have corresponding unit tests. All public API endpoints MUST have integration tests. Critical calculation paths (fee computation, weather condition evaluation) MUST achieve minimum 80% line coverage.

**Rationale:** The project calculates monetary fees based on weather conditions and vehicle types. Incorrect calculations directly impact business revenue and customer trust. Comprehensive testing prevents financial errors and ensures reliability.

**Enforcement:**
- JUnit 5 + Mockito for unit testing
- Spring Boot Test framework for integration testing
- Service layer (DeliveryFeeService) MUST have complete test coverage for all calculation scenarios
- Controller layer MUST validate request/response contracts
- Repository layer MAY use lighter testing (Spring Data JPA abstractions are well-tested)

### Principle 1.2: Test-Driven Development (TDD) Discipline
**Statement:** For new features and bug fixes involving calculation logic, tests SHOULD be written before implementation code (Red-Green-Refactor cycle).

**Rationale:** TDD ensures testability is designed into the system from the start and provides living documentation of expected behavior. Given the financial nature of fee calculations, test-first development reduces the risk of overlooked edge cases.

**Enforcement:**
- Feature development begins with failing test cases
- Refactoring MUST maintain green test suite
- Exceptions allowed for exploratory prototyping, but production code MUST be covered retroactively

### Principle 1.3: Code Review and Pair Approval
**Statement:** All changes to the main branch MUST undergo code review by at least one other developer. Changes to fee calculation logic REQUIRE review by two developers.

**Rationale:** Human review catches logic errors, design flaws, and knowledge silos. Critical financial calculations warrant extra scrutiny.

**Enforcement:**
- Pull request workflow with mandatory approvals
- Reviewer checklist includes: test coverage, logic correctness, adherence to principles
- No direct commits to main branch

---

## Article II: Architecture & Design

### Principle 2.1: Layered MVC Architecture
**Statement:** The project MUST maintain clear separation between Controller, Service, and Repository layers. Each layer has distinct responsibilities and MUST NOT bypass adjacent layers.

**Rationale:** Spring MVC layering provides proven separation of concerns: Controllers handle HTTP, Services contain business logic, Repositories manage persistence. This separation enables independent testing and evolution of each layer.

**Enforcement:**
- **Controllers** (`ee.fujitsu.delivery.controller`): HTTP request/response handling, input validation, error translation. MUST NOT contain business logic.
- **Services** (`ee.fujitsu.delivery.service`): Business logic, fee calculations, weather condition evaluation. MUST NOT depend on HTTP concerns.
- **Repositories** (`ee.fujitsu.delivery.repository`): Data access via Spring Data JPA. MUST return domain entities, not DTOs.
- **Models** (`ee.fujitsu.delivery.model`): JPA entities representing domain concepts. MUST be anemic (no business logic).

### Principle 2.2: Dependency Injection and Loose Coupling
**Statement:** All dependencies between components MUST use Spring's dependency injection. Concrete class instantiation via `new` is FORBIDDEN except for immutable value objects and DTOs.

**Rationale:** Dependency injection enables testability (mock injection), flexibility (implementation swapping), and Spring lifecycle management (singletons, scoping, proxies).

**Enforcement:**
- Constructor injection preferred over field injection (immutability, testability)
- `@Autowired` on constructors for multi-dependency classes
- Favor interfaces for service contracts when abstraction adds value

### Principle 2.3: Single Responsibility Principle (SRP)
**Statement:** Each class and method MUST have one well-defined responsibility. Classes exceeding 300 lines or methods exceeding 30 lines SHOULD be refactored unless complexity is inherent to the domain.

**Rationale:** SRP improves readability, testability, and maintainability. Fee calculation logic is complex enough without compounding it with bloated classes.

**Enforcement:**
- Service classes focus on single business capability (e.g., DeliveryFeeService owns fee calculation, not weather data import)
- Extract helper methods or separate classes when complexity grows
- Code review flags SRP violations

---

## Article III: Security & Data Integrity

### Principle 3.1: Input Validation and Sanitization
**Statement:** All external inputs (HTTP request parameters, external API responses) MUST be validated before processing. Invalid inputs MUST result in clear error messages and appropriate HTTP status codes (400 Bad Request).

**Rationale:** Malicious or malformed inputs can cause incorrect calculations, exceptions, or security vulnerabilities. The system processes weather data from external APIs and user-provided parameters (city, vehicle type).

**Enforcement:**
- Bean Validation (`@Valid`, `@NotNull`, etc.) on controller method parameters
- Service layer validates business rules (e.g., city exists in supported list, vehicle type is recognized)
- Custom exception handling translates validation failures to user-friendly responses

### Principle 3.2: No Hardcoded Secrets or Credentials
**Statement:** API keys, database passwords, and other secrets MUST NOT be committed to the repository. Secrets MUST be externalized via environment variables or secure configuration management.

**Rationale:** Hardcoded secrets risk exposure through version control history, log files, or public repositories. Even in-memory H2 databases can have development credentials that leak patterns.

**Enforcement:**
- Use `application.properties` with placeholder syntax: `weather.api.key=${WEATHER_API_KEY}`
- `.gitignore` includes `application-local.properties` and environment-specific overrides
- Production deployments use environment variables or secret vaults

### Principle 3.3: Defensive Programming Against Null and Missing Data
**Statement:** Code MUST handle null values and missing data gracefully. Business logic MUST NOT assume data completeness without explicit validation.

**Rationale:** Weather APIs may return incomplete data (missing temperature, wind speed). Database queries may return empty results. Null pointer exceptions in production are unacceptable.

**Enforcement:**
- Use `Optional<T>` for repository query results that may be absent
- Null checks before dereferencing objects from external sources
- Default fallback values when appropriate (e.g., "normal" weather if no extreme conditions detected)

---

## Article IV: Documentation & Knowledge Sharing

### Principle 4.1: README Completeness
**Statement:** The project README MUST document: project purpose, setup instructions, how to run, how to test, and key architectural decisions. README updates are REQUIRED when setup steps or dependencies change.

**Rationale:** New developers or auditors should be able to understand and run the project within 15 minutes using only the README. Documentation rot leads to time waste and frustration.

**Enforcement:**
- README includes quickstart commands (`mvn clean install`, `mvn spring-boot:run`)
- Prerequisites listed (Java 17, Maven)
- API endpoint examples provided
- Architectural diagram or layer description included

### Principle 4.2: Inline Code Comments for Business Logic
**Statement:** Complex business logic (fee calculation formulas, weather condition thresholds) MUST have explanatory comments. Comments SHOULD explain *why* (rationale) not *what* (code is self-explanatory).

**Rationale:** Fee calculation rules derive from business requirements (e.g., "if wind speed > 20 m/s, car delivery forbidden"). Without comments, future developers must reverse-engineer the domain knowledge.

**Enforcement:**
- JavaDoc on public service methods explaining purpose and edge cases
- Inline comments on calculation formulas referencing requirements (e.g., `// Regional base fee: Tallinn=4€, Tartu=3.5€, Pärnu=3€`)
- No commented-out code in main branch (use version control)

### Principle 4.3: Architecture Decision Records (ADRs) for Major Changes
**Statement:** Significant architectural changes (technology swaps, design pattern changes, major refactors) SHOULD be documented in ADR format (decision, context, consequences).

**Rationale:** Future maintainers need to understand *why* decisions were made to avoid repeating debates or inadvertently breaking assumptions.

**Enforcement:**
- ADRs stored in `docs/adr/` directory
- Numbered sequentially: `001-use-h2-in-memory-db.md`
- Template includes: Status, Context, Decision, Consequences
- Optional but RECOMMENDED for non-trivial changes

---

## Article V: Configuration & Environment Management

### Principle 5.1: Externalized Configuration
**Statement:** Environment-specific values (database URLs, API endpoints, feature flags) MUST be externalized via `application.properties` or Spring profiles. Code MUST NOT contain hardcoded environment assumptions.

**Rationale:** The same codebase deploys to development, testing, and production environments. Configuration must be swappable without code changes.

**Enforcement:**
- Use `application.properties` for defaults
- Use `application-{profile}.properties` for environment overrides (dev, test, prod)
- `@Value` annotations or `@ConfigurationProperties` for injection
- Document all configurable properties in README or `application.properties` comments

### Principle 5.2: Database Schema Management
**Statement:** Database schema MUST be versioned using Spring Boot's built-in schema initialization or a migration tool (Flyway/Liquibase) when project complexity warrants it. Manual schema changes are FORBIDDEN.

**Rationale:** Schema drift between environments causes bugs and deployment failures. Versioned migrations provide auditability and rollback capability.

**Enforcement:**
- Currently using H2 in-memory with `spring.jpa.hibernate.ddl-auto=update` (auto-schema generation)
- If production database is introduced, MUST migrate to Flyway/Liquibase with versioned scripts in `src/main/resources/db/migration/`
- Schema changes require pull request review

---

## Article VI: Build & Deployment

### Principle 6.1: Reproducible Builds
**Statement:** The project MUST build identically on any developer machine and CI/CD environment. Build configuration (Maven POM, dependencies) MUST be version-controlled and complete.

**Rationale:** "Works on my machine" is unacceptable. Reproducibility ensures consistent quality and simplifies troubleshooting.

**Enforcement:**
- Maven wrapper (`mvnw`) included in repository (locks Maven version)
- Dependency versions pinned in `pom.xml` (no floating versions like `LATEST`)
- Build command documented in README: `./mvnw clean install`
- No manual steps required beyond running Maven

### Principle 6.2: Automated Testing in CI Pipeline
**Statement:** Continuous Integration MUST run all tests on every commit to main or pull request. Failing tests MUST block merges.

**Rationale:** Automated testing catches regressions before human reviewers see the code. Broken main branch halts all downstream development.

**Enforcement:**
- GitHub Actions, GitLab CI, or equivalent configured
- Pipeline steps: `mvn test` (unit tests) and `mvn verify` (integration tests)
- Status checks required to pass before merge allowed

---

## Governance & Amendment Process

### Amendment Procedure
1. **Proposal:** Any contributor may propose an amendment by creating a pull request modifying this constitution.
2. **Discussion:** Amendment PR requires review by project maintainers and SHOULD be open for at least 48 hours for feedback.
3. **Approval:** Amendments require approval from at least two-thirds of active maintainers (currently: majority of regular contributors).
4. **Versioning:** Constitution versions follow semantic versioning:
    - **MAJOR** (X.0.0): Backward-incompatible governance changes (principle removals, redefined enforcement)
    - **MINOR** (X.Y.0): New principles or sections added, materially expanded guidance
    - **PATCH** (X.Y.Z): Clarifications, typo fixes, wording improvements without semantic change
5. **Ratification:** Upon merge, update `LAST_AMENDED_DATE` and `CONSTITUTION_VERSION` at the top of this document.

### Compliance Review
- Constitution adherence SHOULD be checked during code reviews (reviewers reference relevant articles).
- Quarterly review of constitution for relevance and necessary updates (schedule in team calendar).
- Non-compliance without justification may result in pull request rejection or refactoring requests.

### Exception Process
- Exceptions to constitutional principles REQUIRE explicit justification in commit message or pull request description.
- Temporary exceptions (e.g., "skipping tests for prototype exploration") MUST include a follow-up task (Jira ticket, GitHub issue) to address the debt.
- Permanent exceptions (e.g., "this legacy module predates Principle X") SHOULD be documented in the codebase with `@SuppressWarnings` or comment blocks.

---

## Technical Guidelines (Current State)

### Technology Stack
- **Language:** Java 17 (LTS)
- **Framework:** Spring Boot 3.2.1
    - Spring Web (REST API)
    - Spring Data JPA (ORM)
    - Spring Boot Test (testing infrastructure)
- **Build Tool:** Apache Maven 3.x
- **Database:** H2 in-memory database (development/testing)
- **Testing:** JUnit 5 + Mockito
- **Documentation:** Markdown (README, ADRs)

### Project Structure
```
FujitsuTrialTask/
├── src/
│   ├── main/
│   │   ├── java/ee/fujitsu/delivery/
│   │   │   ├── DeliveryApplication.java       # Spring Boot entry point
│   │   │   ├── controller/                    # REST controllers
│   │   │   ├── service/                       # Business logic
│   │   │   ├── repository/                    # Data access (Spring Data JPA)
│   │   │   ├── model/                         # JPA entities
│   │   │   └── exception/                     # Custom exceptions
│   │   └── resources/
│   │       ├── application.properties         # Configuration
│   │       └── db/migration/                  # Schema migrations (future)
│   └── test/
│       └── java/ee/fujitsu/delivery/
│           ├── controller/                    # Controller tests
│           ├── service/                       # Service tests
│           └── repository/                    # Repository tests (optional)
├── pom.xml                                    # Maven build configuration
├── README.md                                  # Project documentation
└── constitution.md                            # This document
```

### Build Commands
- **Build:** `./mvnw clean install`
- **Run:** `./mvnw spring-boot:run`
- **Test:** `./mvnw test` (unit tests) or `./mvnw verify` (integration tests)
- **Package:** `./mvnw package` (produces JAR in `target/`)

### Development Workflow
1. Create feature branch from `main`: `git checkout -b feature/description`
2. Implement changes following TDD (write test, implement, refactor)
3. Run tests locally: `./mvnw test`
4. Commit with descriptive message: `git commit -m "feat: add wind speed calculation"`
5. Push and create pull request to `main`
6. Address code review feedback
7. Merge upon approval and passing CI checks

---

## Appendix: Agent Roles Reference

The following specialized AI agents are available for development workflows. Each agent has expertise aligned with specific phases of the development lifecycle. See `~/.ai/5_agents/` for detailed agent capabilities.

| **Workflow Phase**       | **Agent Name**                     | **Role**                                  | **When to Use**                          |
|--------------------------|-----------------------------------|------------------------------------------|------------------------------------------|
| **Foundation**           | Founding Father Franklin          | Constitution architect                   | Creating/updating this constitution      |
| **Speccing**             | Socrates the Questioner           | Conversational spec refinement           | Clarifying vague feature ideas           |
| **Speccing**             | Valdis the Translator             | Jira-to-spec translator                  | Converting Jira tasks to technical specs |
| **Planning**             | Decomposer Dale                   | Spec-to-plan decomposer                  | Breaking specs into implementation plans |
| **Engineering**          | Rex the Red-Green-Refactor        | Spring Boot TDD developer                | Implementing features in Spring Boot     |
| **Engineering**          | Constructor Conway                | Hexagonal architecture bootstrapper      | Setting up new hexagonal projects        |
| **Quality**              | Inspector Insight                 | Spec analyzer                            | Validating spec consistency pre-build    |
| **Quality**              | Judge Dredd Code                  | Code reviewer                            | Rigorous code review enforcement         |
| **Quality**              | Dr. Debugsworth McFixit           | Test failure diagnostician               | Diagnosing and fixing test failures      |

**Note:** This project uses standard Spring MVC architecture (not hexagonal), so **Rex the Red-Green-Refactor** is the primary engineering agent. Constructor Conway is listed for reference but not applicable to this codebase.

**Agent Invocation Examples:**
```
"Have Rex implement the new weather condition logic from specs/042-extreme-weather/spec.md"
"Ask Socrates to help me clarify the regional fee adjustment requirements"
"Have Judge Dredd review the pull request for fee calculation changes"
"Ask Dr. Debugsworth to fix the failing DeliveryFeeServiceTest"
```

---

**End of Constitution**

*This document is the supreme governance authority for FujitsuTrialTask. All development activities, code reviews, and architectural decisions MUST align with these principles. When in doubt, consult this constitution before proceeding.*
