# Engineering Agents

Agents responsible for building features following tech-specific patterns and best practices.

## Available Agents

### 🦖 Rex the Red-Green-Refactor
**File:** `spring-hex-tdd-developer.md`
**Purpose:** Test-Driven Development specialist for Spring Boot & hexagonal architecture
**When to use:** Implementing Spring Boot features with strict TDD discipline
**Tech Stack:** Spring Boot, Hexagonal Architecture, JUnit, Mockito, Testcontainers

**Workflow:**
1. Reads `plan.md` and `tasks.md` (from Decomposer Dale)
2. Loads `.ai/2_tech_stacks/tech-stack-spring.md` for patterns
3. Implements following Red-Green-Refactor TDD cycle
4. Builds domain layer, ports, adapters
5. Writes unit, integration, and e2e tests
6. Hands off to Judge Dredd for code review

### 🏛️ Architect Anya
**File:** `ai-dotfiles-architect.md`
**Purpose:** AI configuration architect specializing in agent-agnostic systems and workflow patterns
**When to use:** Creating new agents, designing configuration architecture, maintaining AI systems
**Tech Stack:** Agent definitions, CLAUDE.md, workflow patterns

**Workflow:**
1. Reads `plan.md` and `tasks.md` (from Decomposer Dale)
2. Loads `.ai/2_tech_stacks/tech-stack-ai.md` for patterns
3. Creates agent definitions with memorable backstories
4. Ensures agent-agnostic language (works across Claude/Copilot/Gemini)
5. Maintains clean separation of concerns (0_core/1_workflows/3_agents/3_specs)
6. Hands off to Judge Dredd for code review

### 🐑 Script Shepherd Shane
**File:** `dotfiles-developer.md`
**Purpose:** Dotfiles developer specializing in shell scripts, environment setup, and cross-platform compatibility
**When to use:** Building shell scripts, BATS tests, installation automation
**Tech Stack:** Shell scripts, BATS testing, Unix tooling

**Workflow:**
1. Reads `plan.md` and `tasks.md` (from Decomposer Dale)
2. Loads `.ai/2_tech_stacks/tech-stack-dotfiles.md` for patterns
3. Creates modular shell functions with BATS tests
4. Ensures cross-platform compatibility (macOS/Linux)
5. Implements idempotent installation scripts
6. Hands off to Judge Dredd for code review

### 🏗️ Constructor Conway
**File:** `spring-hex-bootstrapper.md`
**Purpose:** Hexagonal architecture project bootstrapper for Spring Boot
**When to use:** Starting new Spring Boot projects with clean architecture
**Tech Stack:** Spring Boot, Maven/Gradle, Hexagonal Architecture

**Workflow:**
1. Creates project structure (domain/adapter/application modules)
2. Sets up build configuration and dependencies
3. Generates boilerplate (@Configuration, application.yml)
4. Creates initial test setup
5. Ready for Rex to implement features

## Invocation Examples

```
# Spring Boot implementation
"Implement specs/PROJ-789/ using Rex"
"Use Rex to build the order placement feature with TDD"

# AI configuration work
"Use Anya to create a new planning agent"
"Have Anya refactor the agent structure"

# Dotfiles implementation
"Use Shane to implement the brew setup script"
"Have Shane create BATS tests for git configuration"

# Project bootstrapping
"Use Constructor Conway to bootstrap a new Spring Boot project"
"Bootstrap hexagonal architecture project for order-service"
```
