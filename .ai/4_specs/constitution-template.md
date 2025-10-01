# Project Constitution

This document defines the **non-negotiable principles** for this project. All AI agents and developers MUST follow these rules.

## Core Principles

### 1. Quality Over Speed
- Never bypass pre-commit hooks
- All tests must pass before merging
- Code reviews are mandatory
- Technical debt is addressed, not accumulated

### 2. Test-Driven Development
- Write tests BEFORE implementation
- Follow Red-Green-Refactor cycle
- Maintain minimum 80% code coverage
- Tests must be pristine (no ignored errors)

### 3. Simple & Maintainable
- Favor simple solutions over clever ones
- Readability over conciseness
- Explicit over implicit
- Code should be self-documenting

### 4. Git Discipline
- FORBIDDEN: `--no-verify`, `--force` (without approval)
- Feature branches follow naming convention
- Commits include tracking IDs
- Clear, descriptive commit messages

### 5. Security First
- No secrets in code
- Input validation always
- Security reviews for auth/auth changes
- Compliance with relevant regulations

## Technology Stack

**Primary Tech Stack**: <!-- Reference to .ai/2_tech_stacks/tech-stack-{name}.md -->
```
tech_stack: spring-boot  # Options: spring-boot, dotfiles, python, go, etc.
```

Define your stack here:
- Frontend:
- Backend:
- Database:
- Infrastructure:

**Note**: The `tech_stack` declaration is used by Decomposer Dale to load appropriate planning context from `.ai/2_tech_stacks/tech-stack-{name}.md`

## Coding Standards
- Language version:
- Linter:
- Formatter:
- Testing framework:

## Architecture Patterns
Define your architectural patterns:
- Design pattern: (e.g., Hexagonal, MVC, Clean Architecture)
- Code organization:
- Module boundaries:

## Prohibited Actions
1. Never commit to main directly
2. Never merge without code review
3. Never disable linters/formatters
4. Never skip tests
5. Never commit secrets

## Required Actions
1. Always run pre-commit hooks
2. Always write tests
3. Always update documentation
4. Always add tracking ID to commits
5. Always follow TDD workflow

## Decision Framework
Use Priit's 🟢🟡🔴 framework:
- 🟢 **Autonomous**: Fix tests, linting, typos, imports, formatting
- 🟡 **Collaborative**: Multi-file changes, new features, API changes, database changes
- 🔴 **Ask First**: Rewrites, business logic, security, data loss risk

## Compliance Requirements
Document any compliance needs:
- HIPAA: Yes/No
- GDPR: Yes/No
- SOX: Yes/No
- Other:

---
**Version**: 1.0
**Last Updated**: YYYY-MM-DD
**Owner**:
