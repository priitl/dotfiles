---
title: "Dotfiles Constitution"
version: "1.0"
type: "constitution"
tech_stack: "dotfiles"
---

# Dotfiles Constitution

## Purpose

Agent-agnostic AI development environment configuration working across all AI tools (Claude, Copilot, Gemini, Cursor). This constitution defines foundational principles, architecture decisions, and non-negotiable standards.

## Vision

Create a unified development environment that:
- Works consistently across all AI coding tools
- Enables consistent collaboration patterns
- Maintains portability across macOS and Linux
- Emphasizes modularity, testability, and maintainability

---

# The Five Articles of Development

## Article I: Agent Agnosticism (Write Once, Use Everywhere)

AI configuration shall be tool-agnostic, allowing reuse across different AI platforms without duplication.

### Section 1.1: Shared Core Mandate

All shared logic MUST reside in the `.ai/` directory with the following structure:

- `0_core/` - Personality, standards, decision framework
- `1_workflows/` - TDD, git, pre-commit, spec-driven workflows
- `2_templates/` - Specification templates (spec.md, plan.md, tasks.md)
- `3_commands/` - Spec-kit workflow commands
- `4_tech_stacks/` - Technology-specific patterns
- `5_agents/` - Specialized agents organized by workflow phase

### Section 1.2: Tool Configuration

Tool-specific configurations (`.claude/`, `.copilot/`, `.gemini/`, `.cursor/`) MUST:

- Import from shared core via `@import` directives
- Contain ONLY tool-specific features
- NEVER duplicate shared logic

### Section 1.3: Agent Definitions

Agent definitions MUST:

- Be tool-agnostic and work with any AI platform
- Reference shared workflows from `.ai/1_workflows/`
- Follow the Spec → Plan → Build → Verify workflow

**Rationale:** Reduces maintenance burden, ensures consistency, prevents configuration drift, enables rapid adoption of new AI tools.

**Non-negotiable:**

- NEVER duplicate shared logic in tool-specific configs
- ALWAYS prefer extending shared core over creating tool-specific variations
- Configuration changes MUST work across all supported AI tools

---

## Article II: Unix Philosophy for Scripts

Shell scripts shall follow Unix philosophy: do one thing well, compose easily, maintain simplicity.

### Section 2.1: Script Safety

Every shell script MUST begin with:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Where:
- `-e` exits immediately on error
- `-u` errors on undefined variables
- `-o pipefail` fails pipeline if any command fails

### Section 2.2: Modularity

Scripts MUST:

- Follow Single Responsibility Principle
- Extract reusable logic into `lib/` functions
- Maintain clear separation between config templates, installation logic, and utilities

### Section 2.3: Idempotency

All scripts MUST be safe to run multiple times without adverse effects.

**Rationale:** Enhances testability, improves maintainability, enables reuse and composition, reduces cognitive load.

**Non-negotiable:**

- NEVER create monolithic scripts that do multiple unrelated things
- ALWAYS extract reusable logic into `lib/` functions
- Scripts MUST be idempotent

---

## Article III: Test-First Development

All shell scripts must have BATS tests written before or during implementation. This is NON-NEGOTIABLE.

### Section 3.1: Test Framework

All shell script testing MUST use BATS (Bash Automated Testing System) with:

- bats-support library for additional helpers
- bats-assert library for assertions
- shellcheck for linting

### Section 3.2: Test Types Required

Every shell script implementation MUST include:

1. **Unit tests** - Individual functions in isolation
2. **Integration tests** - Complete workflows
3. **Idempotency tests** - Scripts run twice safely
4. **Platform tests** - Behavior on macOS and Linux

### Section 3.3: Test Location

Test files MUST be colocated with implementation in `tests/` directory.

### Section 3.4: CI/CD Pipeline

CI/CD pipeline MUST:

- Run tests on both macOS and Linux
- Execute on every push
- Block merge if tests fail on either platform

**Rationale:** Ensures scripts work correctly across different environments, provides regression protection, documents expected behavior, prevents "works on my machine™" issues.

**Non-negotiable:**

- NEVER commit shell script changes without corresponding tests
- Tests MUST pass on both macOS and Linux before merge
- NO `--no-verify` flag when committing (pre-commit hooks are mandatory)

---

## Article IV: Spec-Driven Workflow

Complex features shall follow Spec → Plan → Build → Verify workflow using spec-kit templates.

### Section 4.1: Decision Framework

All actions fall into three categories:

**🔴 Always Ask First** - MUST have spec:
- Security-related changes
- Data deletion or migration
- External service integrations
- Anything affecting production
- Business logic decisions

**🟡 Collaborative Actions** - SHOULD have spec:
- Multi-file refactoring
- New features
- Architecture changes
- Breaking API changes
- Performance optimizations

**🟢 Autonomous Actions** - CAN skip spec:
- Fix linting errors
- Fix failing tests
- Add missing test coverage
- Improve documentation clarity
- Fix typos and formatting

### Section 4.2: Specification Structure

Specs MUST:

- Live in `specs/NNN-feature/` directories
- Include `spec.md`, `plan.md`, `tasks.md`
- Use spec-kit Article format (timeless, no temporal references)

### Section 4.3: Specialized Agents

The following specialized agents handle workflow phases:

**Speccing (Requirements → Specifications):**
- Socrates the Questioner - Conversational spec refinement
- Valdis the Translator - Jira → spec translation
- Founding Father Franklin - Bootstrap project constitution

**Planning (Specifications → Plans):**
- Decomposer Dale - Break specs into actionable tasks

**Engineering (Plans → Code):**
- Rex the Red-Green-Refactor - Spring Boot TDD specialist
- Script Shepherd Shane - Shell script & dotfiles specialist
- Architect Anya - AI configuration architect
- Constructor Conway - Spring Boot project bootstrapper

**Quality (Code → Review/Fix):**
- Inspector Insight - Specification consistency analyzer
- Judge Dredd Code - Rigorous code reviewer
- Dr. Debugsworth McFixit - Test failure diagnostician

**Rationale:** Clarifies requirements before implementation, breaks complex work into manageable tasks, provides documentation trail, enables better collaboration.

**Non-negotiable:**

- 🔴 actions MUST have spec
- 🟡 actions SHOULD have spec
- Specs MUST use timeless language (no "new", "recent", "legacy")

---

## Article V: Portable by Default

All scripts and configurations must work on both macOS and Linux without modification.

### Section 5.1: Platform Detection

Platform detection MUST use `uname -s`:

```bash
case "$(uname -s)" in
    Darwin*) # macOS-specific code ;;
    Linux*)  # Linux-specific code ;;
    *)       # Unsupported OS ;;
esac
```

### Section 5.2: Portable Constructs

Scripts MUST:

- Use `#!/usr/bin/env bash` (not `#!/bin/bash`)
- Avoid GNU-specific flags or detect and adapt
- Use portable shell constructs (avoid bashisms when possible)

### Section 5.3: Testing Requirements

All scripts MUST:

- Be tested on both macOS and Linux before merging
- Document any platform-specific limitations clearly

**Rationale:** Supports developers using different operating systems, prevents vendor lock-in, ensures consistent behavior, facilitates team collaboration.

**Non-negotiable:**

- Test on BOTH macOS and Linux before merging
- Use portable shell constructs
- Document platform-specific limitations

---

# Architecture Decisions

## Directory Structure

```
dotfiles/
├── .ai/                     # Agent-agnostic core (shared by all tools)
│   ├── 0_core/             # Personality, standards, decision framework
│   ├── 1_workflows/        # TDD, git, pre-commit, spec-driven
│   ├── 2_templates/        # Spec templates (spec.md, plan.md, tasks.md)
│   ├── 3_commands/         # Spec-kit workflow commands
│   ├── 4_tech_stacks/      # Spring, dotfiles, AI config patterns
│   ├── 5_agents/           # Specialized agents by workflow phase
│   │   ├── 0_speccing/     # Requirements → Specs
│   │   ├── 1_planning/     # Specs → Plans
│   │   ├── 2_engineering/  # Plans → Code
│   │   └── 3_quality/      # Code → Review/Fix
├── .claude/                # Claude-specific wrapper (imports .ai/)
├── .copilot/               # Copilot-specific wrapper (imports .ai/)
├── .gemini/                # Gemini-specific wrapper (imports .ai/)
├── .cursor/                # Cursor-specific wrapper (imports .ai/)
├── install.sh              # Main installation script
├── tests/                  # BATS tests
├── constitution.md         # This document (principles + technical guidelines)
└── AGENTS.md               # Project instructions for AI tools
```

**Rationale:** Clear separation between shared core and tool-specific wrappers enables consistency while allowing tool-specific optimizations.

## Template-Based Configuration

Configuration files use templates with placeholders (e.g., `__GIT_USER_NAME__`) that are populated during installation.

**Rationale:**
- Prevents committing secrets or personal information
- Enables customization without modifying source files
- Provides clear upgrade path when pulling updates
- Documents required configuration values

## Symlink-Based Installation

Dotfiles are symlinked from repository to home directory, with backups created before overwriting existing files.

**Rationale:**
- Changes in repository immediately reflect in active configuration
- Easy updates via git pull
- Preserves user's existing files via timestamped backups
- Enables version control of dotfiles

---

# Technology Constraints

## Required Tools

**Shell:**
- Bash 4.0+ (macOS ships with 3.x, upgrade via Homebrew)
- Zsh with oh-my-zsh and Powerlevel10k

**Testing:**
- BATS (Bash Automated Testing System)
- bats-support and bats-assert libraries
- shellcheck for linting

**Package Management:**
- Homebrew (macOS) or apt/yum (Linux)

**AI Tools (at least one):**
- Claude Code
- GitHub Copilot
- Google Gemini
- Cursor IDE

## Forbidden Practices

**Code Quality:**
- ❌ NEVER use `--no-verify` when committing
- ❌ NEVER disable functionality instead of fixing root cause
- ❌ NEVER create duplicate files to work around issues
- ❌ NEVER commit without tests passing
- ❌ NEVER use temporal references in documentation ("new", "recent", "legacy")

**Shell Scripting:**
- ❌ NEVER omit `set -euo pipefail`
- ❌ NEVER commit scripts without BATS tests
- ❌ NEVER hardcode paths that should be configurable
- ❌ NEVER commit secrets or credentials

**Architecture:**
- ❌ NEVER duplicate agent-agnostic logic in tool-specific configs
- ❌ NEVER create tool-specific workarounds that could be solved in shared core
- ❌ NEVER violate Unix philosophy (monolithic scripts)

---

# Quality Standards

## Test Coverage Requirements

**Shell Scripts:**
- Unit tests for all functions in `lib/`
- Integration tests for installation workflows
- Idempotency tests (script runs twice safely)
- Platform tests (macOS and Linux)

**Success Criteria:**
- All BATS tests pass on macOS
- All BATS tests pass on Linux (GitHub Actions)
- shellcheck passes with no warnings
- Scripts are idempotent

## Code Review Standards

**Shell Scripts:**
- Clear function names describing purpose
- Comments explaining "why", not "what"
- Error handling for all external commands
- Input validation for all user-provided values
- Consistent logging using logging functions

**Documentation:**
- README.md covers all major features
- AGENTS.md provides clear instructions for AI tools
- constitution.md defines timeless principles AND technical guidelines (spec-kit approach)

## Commit Standards

**Format:**

```
Brief description of change (imperative mood)

Optional detailed explanation of why (not what).
```

**Requirements:**
- Pre-commit hooks must pass (no `--no-verify`)
- Tests must pass before committing
- Commits should be atomic (one logical change)
- Commit messages explain "why", not "what"

---

# Evolution and Maintenance

## When to Update This Constitution

This document should be updated when:
- Core architectural principles change
- New non-negotiable standards are established
- Technology constraints shift (new tools, deprecated tools)
- Fundamental workflow changes occur

## How to Propose Changes

1. Create spec in `specs/NNN-constitution-change/`
2. Use Socrates or Valdis to clarify requirements
3. Use Decomposer Dale to plan implementation
4. Review with human developer before implementation
5. Update constitution.md with rationale

## Principles for Evolution

- **Stability over novelty** - Don't change for change's sake
- **Backward compatibility** - Minimize breaking changes
- **Clear migration path** - Document how to upgrade
- **Timeless writing** - No temporal references ("recently", "new")

---

# Success Metrics

This dotfiles project succeeds when:

✅ AI tools consistently produce high-quality, tested code
✅ Configuration works identically across Claude, Copilot, Gemini, Cursor
✅ Installation script works reliably on macOS and Linux
✅ Developers can onboard new machines in under 30 minutes
✅ Pre-commit hooks prevent low-quality commits
✅ Test suite catches regressions before they reach main
✅ Documentation accurately reflects current state
✅ Specialized agents reduce context switching and improve productivity

---

# Conclusion

This constitution provides the foundation for a maintainable, portable, agent-agnostic development environment. By adhering to these principles, we ensure consistency, quality, and long-term sustainability.

**When in doubt, refer back to the Five Articles:**

1. **Agent Agnosticism** - Write Once, Use Everywhere
2. **Unix Philosophy** - Do one thing well, compose easily
3. **Test-First Development** - Tests before code, always
4. **Spec-Driven Workflow** - 🟢🟡🔴 decision framework
5. **Portable by Default** - Works on macOS and Linux

---

**Version**: 1.0.0 | **Ratified**: 2025-01-15 | **Last Amended**: 2025-01-15
