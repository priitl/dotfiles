<!--
SYNC IMPACT REPORT
==================
Constitution Version: 1.0.0 (Initial creation)
Ratification Date: 2025-10-04
Last Amendment: 2025-10-04

CHANGES:
- Initial constitution created from template
- Defined 5 core principles for Spring Boot REST API development
- Established governance rules for maintenance and amendments

MODIFIED PRINCIPLES: None (initial version)
ADDED SECTIONS:
- I. Test-Driven Development
- II. REST API Design
- III. Error Handling
- IV. Code Quality
- V. Data Persistence
- Technology Stack
- Code Review & Quality Gates
- Governance

REMOVED SECTIONS: None (initial version)

TEMPLATE CONSISTENCY:
✅ .ai/2_templates/plan-template.md - reviewed, consistent
✅ .ai/2_templates/spec-template.md - reviewed, consistent
✅ .ai/2_templates/tasks-template.md - reviewed, consistent
✅ .ai/3_commands/*.md - reviewed, consistent

FOLLOW-UP TODOs: None
-->

# Fujitsu Trial Task Constitution

## Core Principles

### I. Test-Driven Development (NON-NEGOTIABLE)
All business logic MUST be verified through comprehensive tests before implementation is considered complete. Test coverage must include:
- Unit tests for service layer logic
- Integration tests for REST endpoints
- Edge case validation (boundary conditions, exceptional weather)
- Test data isolation using H2 test database

**Rationale**: Weather-based fee calculation involves complex conditional logic that is error-prone without systematic testing. TDD ensures correctness and prevents regressions.

### II. REST API Design
Public APIs MUST follow RESTful conventions and maintain backward compatibility:
- Use appropriate HTTP methods (GET for queries)
- Return appropriate status codes (200 OK, 400 Bad Request, 500 Internal Server Error)
- Use query parameters for filtering and optional inputs
- Document all endpoints with parameter descriptions and return types
- Maintain API contracts - breaking changes require versioning

**Rationale**: Consistent API design ensures client integration reliability and reduces support burden.

### III. Error Handling
All exceptions MUST be handled with domain-specific exception types and meaningful messages:
- Custom exceptions for business rule violations (`WeatherConditionException`, `DeliveryFeeException`)
- Global error handling via `@ControllerAdvice`
- Client-friendly error messages without internal implementation details
- Proper logging at appropriate levels (INFO for requests, ERROR for exceptions)

**Rationale**: Clear error handling improves debugging, provides better client experience, and protects internal system details.

### IV. Code Quality
Code MUST be maintainable, readable, and follow Java/Spring Boot conventions:
- Meaningful variable and method names
- Single Responsibility Principle for classes and methods
- Proper separation of concerns (Controller → Service → Repository)
- Use Lombok to reduce boilerplate
- Consistent formatting and style

**Rationale**: High code quality reduces technical debt and makes the codebase approachable for future developers.

### V. Data Persistence
Data access MUST be abstracted through repository pattern with proper entity mapping:
- JPA entities with appropriate annotations
- Composite keys where business logic requires (e.g., station + timestamp)
- Repository interfaces extending Spring Data JPA
- Transaction boundaries clearly defined
- H2 database for development and testing

**Rationale**: Repository pattern provides clean abstraction over data access and enables easy testing without external dependencies.

## Technology Stack

**Core Technologies** (MUST be used):
- Java 17+
- Spring Boot 3.2.3
- Spring Data JPA
- H2 Database (embedded)
- Lombok
- JUnit 5 + Spring Test

**Build Tool**:
- Gradle with standard Spring Boot plugin configuration

**Prohibited**:
- Direct JDBC manipulation (use JPA repositories)
- Reflection for business logic
- Thread.sleep in production code

## Code Review & Quality Gates

**Before Merge** (MUST pass):
1. All tests passing (`./gradlew test`)
2. No compilation warnings
3. Code formatting consistent with project style
4. Business logic covered by tests
5. API contracts documented

**Review Focus Areas**:
- Exception handling completeness
- Test coverage of edge cases
- REST endpoint design consistency
- Separation of concerns

## Governance

**Amendment Process**:
1. Propose change with rationale in pull request or project discussion
2. Update constitution version following semantic versioning:
   - MAJOR: Backward incompatible changes (e.g., removing a principle)
   - MINOR: New principle or section added
   - PATCH: Clarifications, typo fixes, non-semantic updates
3. Update `LAST_AMENDED_DATE` to amendment date
4. Update Sync Impact Report at top of document

**Compliance**:
- All pull requests MUST verify alignment with these principles
- New features MUST include tests per Principle I
- API changes MUST maintain backward compatibility per Principle II
- Deviations from principles MUST be explicitly justified and documented

**Versioning**:
Constitution changes are tracked through git history and the Sync Impact Report.

**Version**: 1.0.0 | **Ratified**: 2025-10-04 | **Last Amended**: 2025-10-04
