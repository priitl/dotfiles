<!--
SYNC IMPACT REPORT
==================
Version Change: N/A → 1.0.0 (initial constitution)
Modified Principles: N/A (new constitution)
Added Sections: All sections (initial creation)
Removed Sections: None

Template Consistency:
- ✅ .ai/2_templates/plan-template.md - Reviewed, aligns with principles
- ✅ .ai/2_templates/spec-template.md - Reviewed, aligns with principles
- ✅ .ai/2_templates/tasks-template.md - Reviewed, aligns with principles
- ✅ .ai/3_commands/*.md - Reviewed, no outdated references

Follow-up TODOs:
- None (all placeholders resolved)
-->

# Project Constitution

**Version**: 1.0.0
**Ratified**: 2025-10-04
**Last Amended**: 2025-10-04

---

## Article I: Project Identity

**Project Name**: Fujitsu Trial Task - Food Delivery Fee Calculator

**Project Purpose**: Calculate food delivery fees based on real-time weather conditions in Estonian cities (Tallinn, Tartu, Pärnu). The system integrates with the Estonian Environment Agency's weather API to determine delivery fees considering temperature, wind speed, and weather phenomena.

**Primary Stakeholders**:
- Development Team (maintainers and contributors)
- Code Reviewers (quality gatekeepers)
- End Users (API consumers - delivery platforms and services)

**Success Criteria**:
1. Accurate fee calculation based on current weather conditions
2. Reliable weather data integration with < 5 minute staleness
3. Comprehensive test coverage (>80% for business logic)
4. Well-documented REST API with OpenAPI specification
5. Maintainable codebase following established Java/Spring Boot conventions

---

## Article II: Architectural Principles

### Principle 1: Layered Architecture Pattern
The system MUST maintain clear separation between presentation, business logic, and data access layers:
- **Controller Layer**: REST endpoints, request/response handling, validation
- **Service Layer**: Business logic, fee calculation algorithms, orchestration
- **Repository/Entity Layer**: Data persistence, entity management, database operations

**Rationale**: Layered architecture provides clear boundaries, testability, and maintainability. Each layer has a single responsibility and dependencies flow in one direction (Controller → Service → Repository).

### Principle 2: Domain-Driven Design for Business Rules
Business logic MUST be encapsulated in domain services and entities, not scattered across controllers or repositories:
- Fee calculation rules reside in `DeliveryFeeService`
- Weather station mappings centralized in `WeatherStationConstants`
- Business entities (`WeatherData`, `DeliveryFeeRequest`) model the domain clearly

**Rationale**: Centralizing business logic makes rules explicit, testable in isolation, and easier to modify when requirements change.

### Principle 3: External Integration Resilience
Weather API integration MUST handle failures gracefully:
- Cache weather data to serve requests during API outages
- Implement retry logic with exponential backoff
- Provide fallback mechanisms for stale data scenarios
- Log integration failures for monitoring and alerting

**Rationale**: External dependencies are unreliable. The system must degrade gracefully rather than fail completely when weather data is unavailable.

### Principle 4: API-First Design
REST API design MUST prioritize:
- OpenAPI specification as source of truth (`docs/openapi.yaml`)
- Consistent response formats (success, error, validation failures)
- Semantic HTTP status codes (200, 400, 404, 500)
- Versioned endpoints for backward compatibility

**Rationale**: API consumers depend on stable, well-documented contracts. Breaking changes must be managed through versioning.

---

## Article III: Code Quality Standards

### Principle 5: Test-Driven Development for Business Logic
All business logic MUST be covered by unit tests written before or alongside implementation:
- Service layer: >80% code coverage
- Unit tests: Use Mockito for isolation
- Integration tests: Validate end-to-end flows with in-memory H2 database
- Test naming: `should[ExpectedBehavior]When[Condition]` convention

**Rationale**: TDD ensures testable design, catches regressions early, and serves as living documentation of expected behavior.

### Principle 6: Code Clarity Over Cleverness
Code MUST prioritize readability and maintainability:
- Self-documenting method and variable names
- Business logic methods < 30 lines
- Avoid deep nesting (max 3 levels)
- Extract complex conditionals into named boolean methods
- Comments explain "why", not "what"

**Rationale**: Code is read 10x more than written. Future maintainers (including future you) need to understand intent quickly.

### Principle 7: Dependency Management Discipline
Dependencies MUST be:
- Minimal: Only include what's actively used
- Up-to-date: Patch versions updated monthly, minor versions quarterly
- Vetted: Security vulnerabilities addressed within 1 week of disclosure
- Spring Boot starters preferred over individual libraries

**Rationale**: Dependency bloat increases attack surface and maintenance burden. Keeping dependencies current prevents security debt.

### Principle 8: Error Handling and Observability
Error handling MUST be:
- Explicit: No swallowed exceptions
- Informative: Error messages include context for debugging
- Logged: All errors logged with appropriate severity
- User-friendly: API responses hide internal details, expose actionable messages

**Rationale**: Good error handling enables rapid diagnosis of issues in production and better user experience.

---

## Article IV: Development Workflow

### Principle 9: Git Workflow Standards
Version control MUST follow:
- Feature branches from `master` (or `main`)
- Descriptive branch names: `feature/`, `bugfix/`, `refactor/`
- Atomic commits with conventional commit messages
- Pull requests required for all changes to main branch
- Code review approval required before merge

**Rationale**: Structured git workflow enables collaboration, code review, and traceability of changes.

### Principle 10: Continuous Integration Requirements
All code MUST pass automated checks before merge:
- Unit tests: All tests pass
- Integration tests: All tests pass
- Code formatting: Checkstyle or Spring Java Format applied
- Build: Maven build succeeds without warnings
- Security: Dependency vulnerability scans pass

**Rationale**: Automated quality gates prevent regressions and maintain consistent code quality.

---

## Article V: Technical Stack Governance

### Section 1: Core Technologies
- **Language**: Java (Latest LTS version, currently Java 17+)
- **Framework**: Spring Boot (Latest stable version, currently 3.x)
- **Build Tool**: Maven (Latest stable version)
- **Database**: H2 (in-memory for development/testing), PostgreSQL (production-ready option)
- **Testing**: JUnit 5, Mockito, Spring Boot Test

**Rationale**: Spring Boot ecosystem provides mature, well-supported tools for enterprise Java development. LTS Java versions ensure long-term stability.

### Section 2: Operational Requirements
- **Logging**: SLF4J with Logback (Spring Boot default)
- **Configuration**: Spring Boot application.properties with environment-specific overrides
- **API Documentation**: OpenAPI 3.0 specification maintained in `docs/openapi.yaml`
- **Monitoring**: Actuator endpoints enabled for health checks and metrics

**Rationale**: Operational maturity requires structured logging, flexible configuration, and runtime observability.

---

## Article VI: Governance and Evolution

### Section 1: Amendment Process
This constitution may be amended by:
1. Proposing changes via pull request with rationale
2. Review by project maintainers
3. Approval by majority vote (for team projects) or lead maintainer (for individual projects)
4. Version number incremented according to semantic versioning:
   - **MAJOR**: Backward-incompatible principle changes (e.g., removing a testing requirement)
   - **MINOR**: New principles or sections added
   - **PATCH**: Clarifications, wording improvements, typo fixes

### Section 2: Compliance and Review
- **Periodic Review**: Constitution reviewed quarterly or when major project changes occur
- **Violation Handling**: Non-compliance addressed in code review before merge
- **Template Synchronization**: All template files (`.ai/2_templates/*.md`) MUST align with constitutional principles
- **Ratification Date**: Date of initial adoption (2025-10-04)
- **Last Amended Date**: Date of most recent change (2025-10-04)

**Rationale**: Constitutions must evolve with projects but remain stable enough to guide decisions. Regular review ensures principles stay relevant.

---

## Appendix A: Decision Framework

When making technical decisions not explicitly covered by this constitution:

1. **Does it improve maintainability?** (Favor clarity over cleverness)
2. **Is it testable?** (Prefer designs that enable testing)
3. **Does it follow Spring Boot conventions?** (Don't fight the framework)
4. **Will it scale?** (Consider future growth, but don't over-engineer)
5. **Is it documented?** (Code + tests + API docs)

**Tie-breaker**: Choose the simpler option. Complexity should be justified by clear benefits.

---

*This constitution serves as the foundational governance document for the Fujitsu Trial Task project. All code, architecture, and workflow decisions should align with these principles.*
