# Project Bootstrap: [PROJECT NAME]

**Created**: [DATE]
**Status**: In Progress
**Input**: User description: "$ARGUMENTS"

## Execution Flow (main)
```
1. Parse user description from Input
   → If empty: ASK "What kind of project are you bootstrapping?"
2. Determine tech stack
   → Ask: "What is your tech stack?" (language, framework, architecture)
   → If unclear: Provide options based on common patterns
3. Determine architecture style
   → Ask: "What architecture pattern?" (hexagonal, clean, layered, microservices, CLI tool)
   → Load appropriate tech stack doc from ~/.ai/3_tech_stacks/ (from home directory)
4. Determine build tooling
   → Ask: "What build tool?" (Maven/Gradle, npm/pnpm, Make, Poetry)
   → Ask: "Multi-module or monorepo?"
5. Determine testing approach
   → Ask: "What testing frameworks?" (JUnit, pytest, Jest, BATS)
   → Ask: "Integration test strategy?" (Testcontainers, mocks, in-memory)
6. Determine quality tooling
   → Ask: "What quality tools?" (linters, formatters, static analyzers)
   → Ask: "Pre-commit hooks?"
7. Determine persistence needs (if applicable)
   → Ask: "Does this project need a database?"
   → If yes: "What database?" (PostgreSQL, MySQL, MongoDB, etc.)
   → If yes: "What migration tool?" (Liquibase, Flyway, Alembic)
8. Ask about optional features
   → "Include example scaffold?" (yes/no)
   → "Generate documentation?" (README, ARCHITECTURE.md)
9. Create constitution.md if not exists
   → Encode all decisions as constitutional principles
10. Generate project structure
    → Create directories, config files, dependencies
11. Validate and test
    → Run build, verify compilation
12. Return: SUCCESS (project ready for /specify)
```

---

## ⚡ Quick Guidelines
- ✅ NEVER assume - ALWAYS ask
- ✅ Ask follow-up questions based on previous answers
- ✅ Provide options when user is uncertain
- ❌ Don't proceed until all decisions are clear

### Questioning Strategy
1. **Start broad**: Tech stack, language, framework
2. **Go deeper**: Architecture, patterns, structure
3. **Get specific**: Build tools, dependencies, versions
4. **Finalize details**: Testing, quality, optional features

---

## Project Configuration *(filled during execution)*

### Tech Stack Decisions
**Input Description**: $ARGUMENTS

**Language & Framework**:
- [NEEDS ANSWER: What programming language?]
- [NEEDS ANSWER: What framework or runtime? (e.g., Spring Boot, Express, FastAPI, bash)]

**Architecture Pattern**:
- [NEEDS ANSWER: What architecture style? (hexagonal, clean, layered, microservices, monorepo, CLI tool)]

**Build System**:
- [NEEDS ANSWER: What build tool? (Maven, Gradle, npm, pnpm, Make, Poetry, pip)]
- [NEEDS ANSWER: Single module or multi-module?]

### Project Metadata
- **Project Name**: [NEEDS ANSWER]
- **Group/Organization ID**: [NEEDS ANSWER: e.g., com.company, @org, package namespace]
- **Artifact/Package ID**: [NEEDS ANSWER: e.g., my-service, my-cli]
- **Base Package/Module**: [NEEDS ANSWER: e.g., com.company.myservice, myapp]
- **Version**: [NEEDS ANSWER: e.g., 0.1.0-SNAPSHOT, 1.0.0]

### Testing Strategy
**Test Frameworks**:
- [NEEDS ANSWER: Unit test framework? (JUnit 5, pytest, Jest, BATS)]
- [NEEDS ANSWER: Assertion library? (AssertJ, Chai, built-in)]
- [NEEDS ANSWER: Mocking library? (Mockito, unittest.mock, Jest mocks)]

**Integration Testing**:
- [NEEDS ANSWER: Integration test approach? (Testcontainers, test doubles, in-memory)]
- [NEEDS ANSWER: E2E testing needed? (yes/no, if yes: which framework?)]

### Quality & Tooling
**Code Quality**:
- [NEEDS ANSWER: Linter? (Checkstyle, ESLint, Pylint, ShellCheck)]
- [NEEDS ANSWER: Formatter? (Spotless, Prettier, Black, shfmt)]
- [NEEDS ANSWER: Static analyzer? (SpotBugs, SonarQube, MyPy)]
- [NEEDS ANSWER: Coverage tool? (JaCoCo, Coverage.py, Jest coverage)]

**Development Tools**:
- [NEEDS ANSWER: Pre-commit hooks? (yes/no)]
- [NEEDS ANSWER: CI/CD configuration? (GitHub Actions, GitLab CI, none)]
- [NEEDS ANSWER: Containerization? (Docker, Podman, none)]

### Persistence (if applicable)
- [NEEDS ANSWER: Does this project need database persistence? (yes/no)]
- If yes:
  - [NEEDS ANSWER: Database type? (PostgreSQL, MySQL, MongoDB, SQLite)]
  - [NEEDS ANSWER: Migration tool? (Liquibase, Flyway, Alembic, none)]
  - [NEEDS ANSWER: ORM/Data layer? (JPA/Hibernate, SQLAlchemy, raw SQL)]

### Optional Features
- [NEEDS ANSWER: Include example scaffold demonstrating architecture? (yes/no)]
- [NEEDS ANSWER: Generate README.md? (yes/no)]
- [NEEDS ANSWER: Generate ARCHITECTURE.md? (yes/no)]
- [NEEDS ANSWER: Create sample configuration files? (yes/no)]

---

## Module Structure *(generated based on decisions)*

### Directory Layout
```
[Will be generated based on architecture and tech stack decisions]
```

### Key Files to Generate
- [ ] Build configuration (pom.xml, package.json, etc.)
- [ ] Main entry point
- [ ] Configuration files
- [ ] Test infrastructure
- [ ] Quality tool configuration
- [ ] .gitignore
- [ ] README.md (if requested)
- [ ] ARCHITECTURE.md (if requested)

---

## Constitutional Principles *(encoded from decisions)*

The following principles will be encoded in `constitution.md`:

### Tech Stack Principles
- **Language**: [Based on user answers]
- **Framework**: [Based on user answers]
- **Build Tool**: [Based on user answers]

### Architecture Principles
- **Style**: [Based on user answers]
- **Layers**: [Based on architecture choice]
- **Dependency Rules**: [Based on architecture choice]

### Testing Principles
- **Test-First Development**: [Always required]
- **Test Frameworks**: [Based on user answers]
- **Coverage Requirements**: [Based on user answers]

### Quality Principles
- **Code Quality Tools**: [Based on user answers]
- **Formatting Standards**: [Based on user answers]
- **Pre-commit Hooks**: [Based on user answers]

---

## Execution Status
*Updated by main() during processing*

- [ ] User description parsed
- [ ] Tech stack determined
- [ ] Architecture style determined
- [ ] Build tooling decided
- [ ] Testing strategy defined
- [ ] Quality tooling selected
- [ ] Persistence approach decided (if applicable)
- [ ] Optional features selected
- [ ] Constitution created/updated
- [ ] Project structure generated
- [ ] Build validated
- [ ] Ready for /specify

---

## Post-Bootstrap Next Steps

Once bootstrap completes:
1. ✅ Project structure created
2. ✅ Constitution established
3. ✅ Build verified
4. → Next: Run `/specify [your first feature]` to start development
