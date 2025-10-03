---
description: Bootstrap a new Spring Boot project with hexagonal architecture following constitution principles
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Goal: Create a complete Spring Boot project structure following hexagonal architecture patterns, tech stack specifications, and constitutional principles. This command initializes a greenfield project with proper module structure, dependencies, and foundational code.

Constitution Authority: The project constitution (`constitution.md`) is **mandatory**. All architectural decisions, tech stack choices, and coding standards MUST align with constitutional principles. If constitution.md does not exist, abort and instruct user to run `/constitution` first.

Execution steps:

1. Validate prerequisites:
   - Verify `constitution.md` exists at project root
   - Read constitution.md for tech stack, architecture style, and principles
   - Load `.ai/4_tech_stacks/tech-stack-spring-hex.md` for hexagonal architecture patterns
   - Extract project metadata from arguments or constitution (group ID, artifact ID, base package)

2. Determine project structure:
   - Parse constitution for module organization preferences
   - Identify required modules: domain (api, impl, ports), adapter (web, database, database-migration), application
   - Check if multi-module Maven/Gradle structure is specified
   - Determine build tool (Maven/Gradle) from constitution

3. Generate project skeleton:
   - Create root directory structure
   - Generate build configuration (pom.xml or build.gradle)
   - Set up module structure following hexagonal architecture
   - Create package hierarchy (domain, adapter, application layers)

4. Initialize foundational components:
   - Create Spring Boot main application class
   - Set up application.yml/properties with sensible defaults
   - Configure Clock bean for time injection (testability)
   - Add basic configuration classes for each layer

5. Set up testing infrastructure:
   - Add test dependencies (JUnit 5, Mockito, AssertJ, Testcontainers)
   - Create test base classes and utilities
   - Set up integration test configuration
   - Add sample unit and integration test templates

6. Initialize database layer:
   - Set up Liquibase/Flyway migration structure
   - Create initial changelog file
   - Configure database connection properties
   - Add sample migration (if schema exists in constitution)

7. Add quality tooling:
   - Configure Maven/Gradle plugins (checkstyle, spotbugs, jacoco)
   - Set up pre-commit hooks configuration
   - Add .gitignore for Java projects
   - Configure CI-ready build scripts

8. Create example scaffold (optional):
   - If requested, create sample use case (e.g., "GetHealth")
   - Implement port/adapter pattern example
   - Add corresponding tests
   - Include REST endpoint example

9. Documentation:
   - Generate README.md with build/run instructions
   - Create ARCHITECTURE.md explaining hexagonal structure
   - Add inline comments explaining patterns
   - Reference constitution.md for principles

10. Final validation:
    - Verify all modules compile
    - Run `mvn verify` or `gradle build`
    - Ensure tests pass (if example scaffold created)
    - Confirm structure follows constitution principles

11. Report completion:
    - Summarize created modules and structure
    - Provide next steps (run `/specify` to add features)
    - List build commands and how to run the application
    - Highlight key architectural boundaries

Note: This command creates the PROJECT STRUCTURE only. To add features, use the spec-driven workflow: `/specify` → `/plan` → `/tasks` → `/implement`.
